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
#import "GWDeckViewController.h"
#import "GWGridPieceCharacter.h"
#import "GWCharacter.h"
#import "GWGrid.h"
#import "GWGridTile.h"
#import "GWDeckCell.h"
#import "GWDeckCellView.h"

@interface GWGameViewController ()

@property(nonatomic, strong)GWGridViewController *gridController;
@property(nonatomic, strong)GWInfoBoxViewController *infoBoxController;
@property(nonatomic, strong)GWDeckViewController *deckController;

@end

@implementation GWGameViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    // Create grid
    GWGrid *grid = [[GWGrid alloc] init];
    grid.tileSize = CGSizeMake(37.5f, 37.5f);
    [grid gridWithNumHorTiles:8 withNumVertTile:10];
    
    
    // Create info box controller
    _infoBoxController = [[GWInfoBoxViewController alloc] init];
    
    // Set tile on click for grid
    __weak GWGameViewController *weak = self;
    GWGridTileOnClick onTileClickblock = ^(GWGridTile *tile) {
        
        GWGameViewController *strong = weak;
        
        if (tile.hidden) return;
        
        GWGrid *grid = strong.gridController.grid;
        
        if (grid.state == kGWGridStateMoving) {
            switch (tile.state) {
                    // Move destination
                case kGWTileStateSelectableAsMovingDestination:
                    // Update tile ui
                    [strong.gridController moveToCoordinate:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col]];
                    break;
                    // Cancel moving
                case kGWTileStateSelectableForCancel:
                    [strong.gridController cancelMoving];
                    break;
                    
                default:
                    break;
            }
            [strong.infoBoxController clearView];
        } else {
            // Initiate moving if tile can do so and if tile is not busy
            GWGridPieceCharacter *characterPiece = [tile getCharacterPiece];
            if (characterPiece) {
                
                [strong.infoBoxController setGridViewForCharacterPiece:characterPiece];
                [strong.infoBoxController setRotateButtonHidden:YES];
                
                if (tile.state == kGWTileStateIdle) {
                    GWGridResponse *response = [strong.gridController initiateMovingAtCoordinates:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col]];
                    if (!response.success) [strong.infoBoxController setErrorMessage:response.message];
                }
            }
        }
    };
    
    // Create grid view controller
    _gridController = [[GWGridViewController alloc] initWithGrid:grid atPos:CGPointMake(10.0f, 30.0f)];
    [_gridController setTileOnClickBlock:onTileClickblock];
    
    // Create characters
    GWCharacter *warrior = [[GWCharacter alloc] initWithType:kGWCharacterTypeWarrior];
    GWCharacter *thief = [[GWCharacter alloc] initWithType:kGWCharacterTypeThief];
    GWCharacter *priest = [[GWCharacter alloc] initWithType:kGWCharacterTypePriest];
    GWCharacter *archer = [[GWCharacter alloc] initWithType:kGWCharacterTypeArcher];
    GWCharacter *mage = [[GWCharacter alloc] initWithType:kGWCharacterTypeMage];
    
    // Create deck cells
    NSArray *deckCells = @[
                              [[GWDeckCell alloc] initWithCharacter:warrior],
                              [[GWDeckCell alloc] initWithCharacter:thief],
                              [[GWDeckCell alloc] initWithCharacter:priest],
                              [[GWDeckCell alloc] initWithCharacter:archer],
                              [[GWDeckCell alloc] initWithCharacter:mage],
                          ];
    
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
                [strong.infoBoxController setDeckViewForCharacterPiece:strongCellView.cellData.characterPiece];
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
            NSLog(@"Touch Ended!");
            GWDeckCellView *strongCellView = weakCellView;
            GWGameViewController *strong = weak;
            
            if (strongCellView.cellData.type == kGWDeckCellTypeCharacter) {
                if (strong.gridController.grid.state == kGWGridStateSummoning) {
                    
                    // Convert to point on screen
                    point = [strong.deckController convertToOnScreenLocation:point];
                    
                    GWGridTile *tile = [strong.gridController tileForLocation:point];
                    
                    assert(tile);
                    
                    // Successfully ended drag and summoned a character on grid
                    [strong.gridController summonCharacter:strongCellView.cellData.characterPiece atCoordinates:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col]];
                    [strongCellView removeFromSuperview];
                    [strong.infoBoxController clearView];
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
                [strong.infoBoxController setDeckViewForCharacterPiece:strongCellView.cellData.characterPiece];
            }
        };
        
        [cellView setOnTouchBlock:onTouchBlock];
        [cellView setOnPanBlock:onPanBlock];
        [cellView setOnEndBlock:onEndBlock];
        [cellView setOnTapBlock:onTapBlock];
        
        [cellViews addObject:cellView];
    }
    
    // Create deck controller
    _deckController = [[GWDeckViewController alloc] initWithCellViews:cellViews];
    
    // Add child controllers
    [self addChildViewController:_gridController];
    [self addChildViewController:_deckController];
    [self addChildViewController:_infoBoxController];
    
    // Add subviews
    [self.view addSubview:_gridController.view];
    [self.view addSubview:_infoBoxController.view];
    [self.view addSubview:_deckController.view];
    
    return self;
}

- (void) addCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    NSString *uuid = characterPiece.character.uuid.UUIDString;
    NSMutableDictionary *characters = [_characters mutableCopy];
    characters[uuid] = characterPiece;
}

@end
