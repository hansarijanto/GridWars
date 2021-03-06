//
//  GWGameViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGameViewController.h"
#import "GWGridViewController.h"
#import "GWInfoBoxViewController.h"
#import "GWBannerViewController.h"
#import "GWDeckViewController.h"
#import "GWGridPieceCharacter.h"
#import "GWCharacter.h"
#import "GWGrid.h"
#import "GWGridTile.h"
#import "GWDeckCell.h"
#import "GWDeckCellView.h"
#import "GWPlayer.h"
#import "GWButton.h"
#import "GWAppDelegate.h"
#import "GWRootViewController.h"
#import "UIScreen+Rotation.h"
#import "GCTurnBasedMatchHelper.h"
#import "GameKitHelper.h"

@interface GWGameViewController () {
    GWButton *_exitButton;
}

@property(nonatomic, strong)GWPlayer *enemy;
@property(nonatomic, strong)GWPlayer *player;
@property(nonatomic, strong)GWGridViewController *gridController;
@property(nonatomic, strong)GWInfoBoxViewController *infoBoxController;
@property(nonatomic, strong)GWDeckViewController *deckController;
@property(nonatomic, strong)GWBannerViewController *bannerController;

@end

@implementation GWGameViewController

- (instancetype)initWithPlayer:(GWPlayer *)player withEnemy:(GWPlayer *)enemy withGrid:(GWGrid *)grid {
    self = [super init];
    if (!self) return nil;
    
    _player = player;
    _enemy = enemy;
    _activePlayer = _player;
    
    // Create banner controller
    _bannerController = [[GWBannerViewController alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 47.5f)];
    
    _exitButton = [[GWButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 30.0f)];
    [_exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [_exitButton addTarget:[GWAppDelegate rootViewController] action:@selector(showCharacterManager) forControlEvents:UIControlEventTouchUpInside];
    [_bannerController.view addSubview:_exitButton];
    
    // Set turn title
    [self setBannerPlayerTurnTitle];
    
    // Create info box controller
    _infoBoxController = [[GWInfoBoxViewController alloc] initWithFrame:CGRectMake(10.0f, UIScreen.mainScreen.orientationRelativeBounds.size.height - 100.0f, 300.0f, 90.0f)];
    
    // Set tile on click for grid
    __weak GWGameViewController *weak = self;
    GWGridTileOnClick onTileTouchblock = ^(GWGridTile *tile) {
        
        GWGameViewController *strong = weak;
        
        if (tile.hidden) return;
        
        
        // Update info box ui
        GWGridPieceCharacter *characterPiece = tile.characterPiece;
        if (characterPiece) {
            
            __weak GWGridPieceCharacter *weakCharacterPiece = characterPiece;
            __weak GWGameViewController *weak = self;
            
            UIButtonBlock claimBlock = ^(id sender, UIEvent *event) {
                GWGridPieceCharacter *strongCharacterPiece = weakCharacterPiece;
                GWGameViewController *strong = weak;
                
                [strong.gridController initiateClaimTerritory:strongCharacterPiece];
            };
            
            [strong.infoBoxController setViewForGridWithCharacterPiece:characterPiece withClaimBlock:claimBlock withPlayer:strong.activePlayer];
            [strong.infoBoxController setRotateButtonHidden:YES];
        }

        // Grid logic selection
        GWGrid *grid = strong.gridController.grid;
        
        switch (grid.state) {
            case kGWGridStateAction:
                [strong.infoBoxController clearView];
                
                switch (tile.state) {
                        // Move destination
                    case kGWTileStateSelectableAsMovingDestination:
                        // Update tile ui
                        [strong.gridController moveToCoordinate:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col]];
                        break;
                        // Cancel moving (on character re-tap)
                    case kGWTileStateSelectableForCancel:
                        // Exit function after cancelling
                        [strong.gridController cancelAction];
                        return;
                    case kGWTileStateSelectableAsAttack:
                        [strong.gridController attackCoordinate:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col]];
                        break;
                    default:
                        // Tapping on an empty tile or player character
                        [strong.gridController cancelAction];
                        break;
                }
                break;
                
            case kGWGridStateIdle:
                if (characterPiece) {
                    GWGridResponse *response = [strong.gridController initiateActionAtCoordinates:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col] withPlayer:strong.activePlayer];
                    if (!response.success) {
                        [strong.infoBoxController setErrorMessage:response.message];
                    }
                }
                
            default:
                break;
        }
    };
    
    // Create grid view controller
    _gridController = [[GWGridViewController alloc] initWithGrid:grid atPos:CGPointMake(10.0f, 67.5f)];
    [_gridController setTileOnClickBlock:onTileTouchblock];
    
    // Add player leader character
    assert(_player.leader);
    GWGridPieceCharacter *playerLeaderPiece = [[GWGridPieceCharacter alloc] initWithCharacter:_player.leader];
    [_gridController addLeaderPiece:playerLeaderPiece];
    
    // Add enemy leader character
//    assert(_enemy.leader);
//    GWGridPieceCharacter *enemyLeaderPiece = [[GWGridPieceCharacter alloc] initWithCharacter:_enemy.leader];
//    [_gridController addLeaderPiece:enemyLeaderPiece];
    
    // Create character deck cells
    NSMutableArray *deckCells = [[NSMutableArray alloc] init];
    
    for (GWCharacter *character in _player.deck) {
        
        // Don't make a deck cell for the leader
        if (character == _player.leader) continue;
        GWDeckCell *deckCell = [[GWDeckCell alloc] initWithCharacter:character];
        [deckCells addObject:deckCell];
    }
    
    // Create cell views for deck
    NSMutableArray *cellViews = [[NSMutableArray alloc] init];
    for (GWDeckCell *cell in deckCells) {
        
        GWDeckCellView *cellView = [[GWDeckCellView alloc] initWithFrame:CGRectZero withCell:cell];
        
        __weak GWDeckCellView *weakCellView = cellView;
        __weak GWGameViewController *weak = self;
        
        // When panning starts
        GWDragableViewBlock onTouchBlock = ^(CGPoint point) {
            GWDeckCellView *strongCellView = weakCellView;
            GWGameViewController *strong = weak;
            NSLog(@"Touch Began!");
            
            // Pannig a character
            if (strongCellView.cellData.type == kGWDeckCellTypeCharacter) {
                [strong.infoBoxController setViewForDeckWithCharacterPiece:strongCellView.cellData.characterPiece];
                [strong.infoBoxController setRotateButtonHidden:YES];
             }
        };
        
        // During panning
        GWDragableViewBlock onPanBlock = ^(CGPoint point) {
            GWDeckCellView *strongCellView = weakCellView;
            GWGameViewController *strong = weak;
            
            // Convert to point on screen
            point = [strong.deckController convertToOnScreenLocation:point];
            
            // Pannig a character
            if (strongCellView.cellData.type == kGWDeckCellTypeCharacter) {
                
                GWGridTile *tile = [strong.gridController tileForLocation:point];
                
                if (tile) {
                    // Set panning cell view position to that of the tile
                    CGPoint tileLocation = [strong.gridController locationForTile:tile];
                    strongCellView.frame = CGRectMake(-strong.deckController.view.frame.origin.x + tileLocation.x, -strong.deckController.view.frame.origin.y + tileLocation.y, CGRectGetWidth(strongCellView.frame), CGRectGetHeight(strongCellView.frame));
                }
                
                // Moved out of grid
                if (!tile) {
                    [strong.gridController cancelSummoning];
                    return;
                }
                
                GWGridPieceCharacter *characterPiece = strongCellView.cellData.characterPiece;
                [strong.gridController initiateSummoningAtCoordinates:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col] forCharacterPiece:characterPiece];
            }
        };
        
        // When panning ends
        GWDragableViewBlock onEndBlock = ^(CGPoint point) {
            NSLog(@"Drag Ended!");
            GWDeckCellView *strongCellView = weakCellView;
            GWGameViewController *strong = weak;
            
            if (strongCellView.cellData.type == kGWDeckCellTypeCharacter) {
                if (strong.gridController.grid.state == kGWGridStateSummoning) {
                    
                    // Convert to point on screen
                    point = [strong.deckController convertToOnScreenLocation:point];
                    
                    GWGridTile *tile = [strong.gridController tileForLocation:point];
                    
                    assert(tile);
                    
                    // Successfully ended drag and summoned a character on grid
                    GWGridResponse *response = [strong.gridController summonCharacter:strongCellView.cellData.characterPiece atCoordinates:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col] withPlayer:strong.activePlayer];
                    
                    if (response.success) {
                        // If succesfully summoned remove deck cell view
                        [strongCellView removeFromSuperview];
                        [strong.infoBoxController clearView];
                    } else {
                        // If not just reset postion
                        [strongCellView resetPosition];
                    }

                    return;
                }
            }
            
            // When summoning a tile and cancels by moving of the grid
            // [strong.infoBoxController clearView];
            [strong.infoBoxController setRotateButtonHidden:NO];
            [strongCellView resetPosition];
        };
        
        // When object is tapped
        dispatch_block_t onTapBlock = ^(void) {
            GWDeckCellView *strongCellView = weakCellView;
            GWGameViewController *strong = weak;
            NSLog(@"Tapped");
            
            // When character is tapped on the deck
            if (strongCellView.cellData.type == kGWDeckCellTypeCharacter) {
                [strong.infoBoxController setViewForDeckWithCharacterPiece:strongCellView.cellData.characterPiece];
            }
        };
        
        [cellView setOnTouchBlock:onTouchBlock];
        [cellView setOnPanBlock:onPanBlock];
        [cellView setOnEndBlock:onEndBlock];
        [cellView setOnTapBlock:onTapBlock];
        
        [cellViews addObject:cellView];
    }
    
    // Create deck controller
    _deckController = [[GWDeckViewController alloc] initWithFrame:CGRectMake(10.0f, UIScreen.mainScreen.orientationRelativeBounds.size.height - 100.0f - 57.5f, 300.0f, 47.5f) withCellViews:cellViews];
    
    // Set end turn block
    UIButtonBlock endTurnBlock = ^(id sender, UIEvent *event) {
        GWGameViewController *strong = weak;
        [strong.infoBoxController clearView];
        [strong endTurn];
    };
    _infoBoxController.button.hidden = NO;
    [_infoBoxController.button setTitle:@"End Turn" forState:UIControlStateNormal];
    [_infoBoxController.button addTarget:self withBlock:endTurnBlock forControlEvents:UIControlEventTouchUpInside];
    
    // Add child controllers
    [self addChildViewController:_gridController];
    [self addChildViewController:_deckController];
    [self addChildViewController:_infoBoxController];
    [self addChildViewController:_bannerController];
    
    // Add subviews
    [self.view addSubview:_gridController.view];
    [self.view addSubview:_infoBoxController.view];
    [self.view addSubview:_deckController.view];
    [self.view addSubview:_bannerController.view];
    
    
    // Create multiplayer manager
    _multiplayerManager = [[MultiplayerNetworking alloc] initWithPlayerData:nil];
    _multiplayerManager.delegate = self;
    
    return self;
}

- (void)endTurn {
    [_gridController endTurn:_activePlayer];
    
    // Switch active player
    if (_activePlayer.team != _player.team) {
        _activePlayer = _player;
    } else {
        _activePlayer = _enemy;
    }
    // Set turn title
    [self setBannerPlayerTurnTitle];
}

- (void)setBannerPlayerTurnTitle {
    // Change banner title to reflect player turn
    NSString *title;
    
    switch (_activePlayer.team) {
        case kGWPlayerRed:
            title = @"Red Player's Turn";
            break;
        case kGWPlayerBlue:
            title = @"Blue Player's Turn";
            break;
            
        default:
            break;
    }
    [_bannerController setTitleWithAnimation:title withColor:_activePlayer.teamColor];
}

#pragma mark - MultiplayerNetworkingProtocol

- (void)beginGameWithPlayerIndex:(NSUInteger)index {
    NSLog(@"beginning game for player %i", index);
    
    // Dismiss match maker view
    [[GameKitHelper sharedGameKitHelper] dismissMatchMaker];
    
    // Display game view
    [[GWAppDelegate rootViewController] changeMainController:self];
}

- (void)gameOver:(BOOL)serverWon {
    NSLog(@"game over");
}

- (void)movePlayerAtIndex:(NSUInteger)index {
}

@end
