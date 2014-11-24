//
//  GWCharacterStoreViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCharacterManagerViewController.h"
#import "GWInfoBoxViewController.h"
#import "GWAppDelegate.h"
#import "GWPlayer.h"
#import "GWCharacter.h"
#import "GWCollectionCellView.h"
#import "GWBannerViewController.h"
#import "GWCollectionView.h"
#import "UIButton+Block.h"
#import "GWButton.h"
#import "GWInfoBoxDeckManagerCharacterView.h"
#import "GWRootViewController.h"
#import "UIScreen+Rotation.h"

@interface GWCharacterManagerViewController ()

@property(nonatomic, strong)GWBannerViewController *bannerController;
@property(nonatomic, strong)UIView *mainView; // middle view;
@end

@implementation GWCharacterManagerViewController {
    GWPlayer *_player;
    GWInfoBoxViewController *_infoBoxController;
    GWButton *_switchButton;
    GWButton *_playButton;
    GWCollectionView *_storeView; // main view for character store
    UIView *_deckManagerView; // main view for deck manager
    GWCollectionView *_deckView; // subview for deck manager
    GWCollectionView *_inventoryView; // subview for deck manager
}

- (instancetype)initWithPlayer:(GWPlayer *)player {
    self = [super init];
    if (!self) return nil;
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 600.f)];
    
    _player = player;
    
    // Create banner controller
    _bannerController = [[GWBannerViewController alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 47.5f)];
    
    // Create main view
    _mainView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Create info box controller
    _infoBoxController = [[GWInfoBoxViewController alloc] initWithFrame:CGRectMake(10.0f, UIScreen.mainScreen.orientationRelativeBounds.size.height - 100.0f, 300.0f, 90.0f)];
    
    // Add child view controllers
    [self addChildViewController:_infoBoxController];
    [self addChildViewController:_bannerController];
    
    [self.view addSubview:_infoBoxController.view];
    [self.view addSubview:_bannerController.view];
    [self.view addSubview:_mainView];
    
    _switchButton = [[GWButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 30.0f)];
    [_bannerController.view addSubview:_switchButton];
    
    _playButton = [[GWButton alloc] initWithFrame:CGRectMake(300.0f - 60.0f, 10.0f, 50.0f, 30.0f)];
    [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton addTarget:[GWAppDelegate rootViewController] action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [_bannerController.view addSubview:_playButton];
    
    [self setViewForDeckManager];
    
    return self;
}

#pragma mark - setter/getter

- (void)setMainView:(UIView *)mainView {
    
    if (_mainView) {
        [_mainView removeFromSuperview];
    }
    _mainView = mainView;
    [self.view addSubview:_mainView];
    _mainView.alpha = 0.0f;
    _mainView.frame = CGRectOffset(_mainView.frame, 0.0f, 500.0f);
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _mainView.alpha = 1.0f;
                         _mainView.frame = CGRectOffset(_mainView.frame, 0.0f, -500.0f);
                     }];
}

#pragma mark - deck manager

// an array of collection cell views for each character in a player's deck
- (NSArray *)deckCellViews {
    NSMutableArray *deckCellViews = [[NSMutableArray alloc] init];
    NSArray *characters = _player.deck;
    for (int i=0; i<[characters count]; ++i) {
        GWCharacter *character = characters[i];
        
        GWCollectionCellView *cell = [[GWCollectionCellView alloc] initWithFrame:CGRectZero withCharacter:character];
        if (_player.leader == character) {
            [cell setBackgroundColor:[UIColor redColor]];
        }
        
        __weak GWCharacter *weakCharacter = character;
        __weak GWPlayer *weakPlayer = _player;
        __weak GWInfoBoxViewController *weakInfoBox = _infoBoxController;
        
        // Remove character from deck
        UIButtonBlock removeButtonBlock = ^(id sender, UIEvent *event) {
            GWCharacter *strongCharacter = weakCharacter;
            GWPlayer *strongPlayer = weakPlayer;
            GWInfoBoxViewController *infoBox = weakInfoBox;
            
            // If character being removed and is a leader reset the leader
            if (strongPlayer.leader == strongCharacter) strongPlayer.leader = nil;
            
            [strongPlayer moveCharacterFromDeckToInventory:strongCharacter];
            [infoBox clearView];
            
            // reload data/ui
            _inventoryView.cells = self.inventoryCellViews;
            _deckView.cells = self.deckCellViews;
        };
        
        cell.button.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        [cell.button setTitle:@"Remove" forState:UIControlStateNormal];
        [cell.button addTarget:self withBlock:removeButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        // Show character info when store cell is pressed
        UIButtonBlock cellButtonBlock = ^(id sender, UIEvent *event) {
            GWInfoBoxViewController *infoBox = weakInfoBox;
            GWCharacter *strongCharacter = weakCharacter;
            
            UIButtonBlock leaderButtonBlock = ^(id sender, UIEvent *event) {
                GWCharacter *strongCharacter = weakCharacter;
                GWPlayer *strongPlayer = weakPlayer;
                
                NSString *title;
                NSString *message;
                if([strongPlayer makeLeader:strongCharacter]) {
                    title = @"Leader";
                    message = [NSString stringWithFormat:@"%@ is now the leader of your team", strongCharacter.characterClass];
                } else {
                    title = @"Oops";
                    message = @"Character must be in your deck if you want to make it your leader";
                }
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                // Reload ui
                _deckView.cells = self.deckCellViews;
            };
            
            [infoBox setViewForDeckManagerWithCharacter:strongCharacter withLeaderButtonBlock:leaderButtonBlock];
        };
        [cell addTarget:self withBlock:cellButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        [deckCellViews addObject:cell];
    }
    
    return (NSArray *)deckCellViews;
}

// an array of collection cell view for each character a player own not in his deck
- (NSArray *)inventoryCellViews {
    // Create store cell views for all characters the player has but is not in their deck
    NSMutableArray *characterCellViews = [[NSMutableArray alloc] init];
    NSArray *characters = _player.inventory;
    for (int i=0; i<[characters count]; ++i) {
        GWCharacter *character = characters[i];
        
        GWCollectionCellView *cell = [[GWCollectionCellView alloc] initWithFrame:CGRectZero withCharacter:character];
        
        __weak GWCharacter *weakCharacter = character;
        __weak GWPlayer *weakPlayer = _player;
        __weak GWInfoBoxViewController *weakInfoBox = _infoBoxController;
        
        // Add character to player when bought
        UIButtonBlock addButtonBlock = ^(id sender, UIEvent *event) {
            GWCharacter *strongCharacter = weakCharacter;
            GWPlayer *strongPlayer = weakPlayer;
            GWInfoBoxViewController *infoBox = weakInfoBox;
            
            [strongPlayer moveCharacterFromInventoryToDeck:strongCharacter];
            [infoBox clearView];
            
            // reload data/ui
            _inventoryView.cells = self.inventoryCellViews;
            _deckView.cells = self.deckCellViews;
        };
        
        // Add character to player when bought
        cell.button.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        [cell.button setTitle:@"Add to Deck" forState:UIControlStateNormal];
        [cell.button addTarget:self withBlock:addButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        // Show character info when store cell is pressed
        UIButtonBlock cellButtonBlock = ^(id sender, UIEvent *event) {
            GWInfoBoxViewController *infoBox = weakInfoBox;
            GWCharacter *strongCharacter = weakCharacter;
            
            [infoBox setViewForStoreWithCharacter:strongCharacter];
        };
        [cell addTarget:self withBlock:cellButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        [characterCellViews addObject:cell];
    }
    
    return (NSArray *)characterCellViews;
}

// an array of collection cell views of every available character
- (NSArray *)storeCellViews {
    NSMutableArray *cellViews = [[NSMutableArray alloc] init];
    
    // Create store cell views for all possible characters
    NSArray *characters = [GWCharacter getAllPossibleCharacters];
    for (int i=0; i<[characters count]; ++i) {
        GWCharacter *character = characters[i];
        
        GWCollectionCellView *cell = [[GWCollectionCellView alloc] initWithFrame:CGRectZero withCharacter:character];
        
        __weak GWCharacter *weakCharacter = character;
        __weak GWPlayer *weakPlayer = _player;
        __weak GWInfoBoxViewController *weakInfoBox = _infoBoxController;
        
        // Add character to player when bought
        UIButtonBlock buyButtonBlock = ^(id sender, UIEvent *event) {
            GWCharacter *strongCharacter = weakCharacter;
            GWPlayer *strongPlayer = weakPlayer;
            GWInfoBoxViewController *infoBox = weakInfoBox;
            
            [strongPlayer addCharacterToInventory:strongCharacter];
            [infoBox setViewForStoreWithCharacter:strongCharacter];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchased!"
                                                            message:[NSString stringWithFormat:@"You got a %@", strongCharacter.characterClass]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        };
        
        [cell.button setTitle:@"Buy" forState:UIControlStateNormal];
        [cell.button addTarget:self withBlock:buyButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        // Show character info when store cell is pressed
        UIButtonBlock cellButtonBlock = ^(id sender, UIEvent *event) {
            GWInfoBoxViewController *infoBox = weakInfoBox;
            GWCharacter *strongCharacter = weakCharacter;
            
            [infoBox setViewForStoreWithCharacter:strongCharacter];
        };
        [cell addTarget:self withBlock:cellButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        [cellViews addObject:cell];
    }
    
    return (NSArray *)cellViews;
}

- (void)setViewForDeckManager {
    
    struct CollectionViewOptions options;
    options.horSpacing  = 10.0f;
    options.vertSpacing = 10.0f;
    options.cellWidth   = 67.5f;
    options.cellHeight  = 100.0f;
    options.colPerRow   = 100;
    
    if (!_deckManagerView || !_inventoryView || !_deckManagerView) {
        
        // Create store cell views for all characters in the player's deck
        UILabel *deckTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 0.0f, 0.0f)];
        deckTitle.text = @"Deck";
        [deckTitle sizeToFit];
        
        UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, deckTitle.frame.origin.y + deckTitle.frame.size.height + 2.0f, 300.0f, 1.0f)];
        [seperator1 setBackgroundColor:[UIColor blackColor]];
        
        _deckView = [[GWCollectionView alloc] initWithFrame:CGRectMake(0.0f, 50.f, 300.0f, 100.0f) withCells:(NSArray *)self.deckCellViews withOptions:options];
        
        // Create store cell views for all characters in the player's deck
        UILabel *inventoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 160.0f, 0.0f, 0.0f)];
        inventoryTitle.text = @"Inventory";
        [inventoryTitle sizeToFit];
        
        UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, inventoryTitle.frame.origin.y + inventoryTitle.frame.size.height + 2.0f, 300.0f, 1.0f)];
        [seperator2 setBackgroundColor:[UIColor blackColor]];
        
        _inventoryView = [[GWCollectionView alloc] initWithFrame:CGRectMake(0.0f, 200.0f, 300.0f, 100.0f) withCells:self.inventoryCellViews withOptions:options];
        
        // Add both views to _deckManagerView
        _deckManagerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 67.5f, 300.0f, 300.0f)];
        [_deckManagerView addSubview:_inventoryView];
        [_deckManagerView addSubview:_deckView];
        [_deckManagerView addSubview:deckTitle];
        [_deckManagerView addSubview:inventoryTitle];
        [_deckManagerView addSubview:seperator1];
        [_deckManagerView addSubview:seperator2];
    } else {
        // Reload data if ui already exist
        _inventoryView.cells = self.inventoryCellViews;
        _deckView.cells = self.deckCellViews;
    }
    
    [_infoBoxController clearView];
    
    // Change switch button to store
    [_switchButton setTitle:@"Store" forState:UIControlStateNormal];
    [_switchButton removeTarget:self action:@selector(setViewForDeckManager) forControlEvents:UIControlEventTouchUpInside];
    [_switchButton addTarget:self action:@selector(setViewForCharacterStore) forControlEvents:UIControlEventTouchUpInside];
    
    [_bannerController setTitleWithAnimation:@"Deck Manager" withColor:[UIColor whiteColor]];
    self.mainView = _deckManagerView;
}


#pragma mark - character store

- (void)setViewForCharacterStore {
    
    struct CollectionViewOptions options;
    options.horSpacing  = 10.0f;
    options.vertSpacing = 10.0f;
    options.cellWidth   = 67.5f;
    options.cellHeight  = 100.0f;
    options.colPerRow   = 4;
    
    if (!_storeView) {
        _storeView = [[GWCollectionView alloc] initWithFrame:CGRectMake(10.0f, 67.5f, 300.0f, 395.0f) withCells:self.storeCellViews withOptions:options];
    } else {
        _storeView.cells = self.storeCellViews;
    }
    
    [_infoBoxController clearView];
    
    // Change switch button to deck
    [_switchButton setTitle:@"Deck" forState:UIControlStateNormal];
    [_switchButton removeTarget:self action:@selector(setViewForCharacterStore) forControlEvents:UIControlEventTouchUpInside];
    [_switchButton addTarget:self action:@selector(setViewForDeckManager) forControlEvents:UIControlEventTouchUpInside];
    
    [_bannerController setTitleWithAnimation:@"Character Store" withColor:[UIColor whiteColor]];
    self.mainView = _storeView;
}

@end
