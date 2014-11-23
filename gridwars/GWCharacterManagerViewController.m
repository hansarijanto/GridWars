//
//  GWCharacterStoreViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCharacterManagerViewController.h"
#import "GWInfoBoxViewController.h"
#import "GWPlayer.h"
#import "GWCharacter.h"
#import "GWCollectionCellView.h"
#import "GWBannerViewController.h"
#import "GWCollectionView.h"
#import "UIButton+Block.h"
#import "GWButton.h"

@interface GWCharacterManagerViewController ()

@property(nonatomic, strong)GWBannerViewController *bannerController;
@property(nonatomic, strong)UIView *mainView; // middle view;
@end

@implementation GWCharacterManagerViewController {
    GWPlayer *_player;
    GWInfoBoxViewController *_infoBoxController;
    UIView *_storeView;
    UIView *_deckManagerView;
    GWButton *_switchButton;
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
    _infoBoxController = [[GWInfoBoxViewController alloc] initWithFrame:CGRectMake(10.0f, 470.0f, 300.0f, 90.0f)];
    
    // Add child view controllers
    [self addChildViewController:_infoBoxController];
    [self addChildViewController:_bannerController];
    
    [self.view addSubview:_infoBoxController.view];
    [self.view addSubview:_bannerController.view];
    [self.view addSubview:_mainView];
    
    _switchButton = [[GWButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 30.0f)];
    [_bannerController.view addSubview:_switchButton];
    
    [self setViewForCharacterStore];
    
    return self;
}

#pragma mark - deck manager

- (void)setViewForDeckManager {
    
    struct CollectionViewOptions options;
    options.horSpacing = 10.0f;
    options.vertSpacing = 10.0f;
    options.cellWidth = 67.5f;
    options.cellHeight = 100.0f;
    options.colPerRow = 100;
    
    // Create store cell views for all characters the player has but is not in their deck
    NSMutableArray *characterCellViews = [[NSMutableArray alloc] init];
    NSArray *characters = _player.characters;
    UIView *charactersView;
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
            
            [strongPlayer moveCharacterFromCharactersToDeck:strongCharacter];
            [infoBox setViewForStoreWithCharacter:strongCharacter];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Added!"
                                                            message:[NSString stringWithFormat:@"%@ has been added to your deck.", strongCharacter.characterClass]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
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
    
    charactersView = [[GWCollectionView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 100.0f) withCells:(NSArray *)characterCellViews withOptions:options];
    
    // Create store cell views for all characters in the player's deck
    NSMutableArray *deckCellViews = [[NSMutableArray alloc] init];
    characters = _player.deck;
    UIView *deckView;
    for (int i=0; i<[characters count]; ++i) {
        GWCharacter *character = characters[i];
        
        GWCollectionCellView *cell = [[GWCollectionCellView alloc] initWithFrame:CGRectZero withCharacter:character];
        
        __weak GWCharacter *weakCharacter = character;
        __weak GWPlayer *weakPlayer = _player;
        __weak GWInfoBoxViewController *weakInfoBox = _infoBoxController;
        
        // Add character to player when bought
        UIButtonBlock removeButtonBlock = ^(id sender, UIEvent *event) {
            GWCharacter *strongCharacter = weakCharacter;
            GWPlayer *strongPlayer = weakPlayer;
            GWInfoBoxViewController *infoBox = weakInfoBox;
            
            [strongPlayer moveCharacterFromDeckToCharacters:strongCharacter];
            [infoBox setViewForStoreWithCharacter:strongCharacter];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Removed!"
                                                            message:[NSString stringWithFormat:@"%@ has been removed from your deck.", strongCharacter.characterClass]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        };
        
        // Add character to player when bought
        cell.button.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        [cell.button setTitle:@"Remove" forState:UIControlStateNormal];
        [cell.button addTarget:self withBlock:removeButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        // Show character info when store cell is pressed
        UIButtonBlock cellButtonBlock = ^(id sender, UIEvent *event) {
            GWInfoBoxViewController *infoBox = weakInfoBox;
            GWCharacter *strongCharacter = weakCharacter;
            
            [infoBox setViewForStoreWithCharacter:strongCharacter];
        };
        [cell addTarget:self withBlock:cellButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        [deckCellViews addObject:cell];
    }
    
    deckView = [[GWCollectionView alloc] initWithFrame:CGRectMake(10.0f, 110.f, 300.0f, 100.0f) withCells:(NSArray *)deckCellViews withOptions:options];
    
    // Add both views to _deckManagerView
    _deckManagerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 67.5f, 300.0f, 395.0f)];
    [_deckManagerView addSubview:charactersView];
    [_deckManagerView addSubview:deckView];
    
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
    options.horSpacing = 10.0f;
    options.vertSpacing = 10.0f;
    options.cellWidth = 67.5f;
    options.cellHeight = 100.0f;
    options.colPerRow = 4;
    
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
            
            [strongPlayer addCharacterToCharacters:strongCharacter];
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
    
    _storeView = [[GWCollectionView alloc] initWithFrame:CGRectMake(10.0f, 67.5f, 300.0f, 395.0f) withCells:(NSArray *)cellViews withOptions:options];
    
    [_infoBoxController clearView];
    
    // Change switch button to deck
    [_switchButton setTitle:@"Deck" forState:UIControlStateNormal];
    [_switchButton removeTarget:self action:@selector(setViewForCharacterStore) forControlEvents:UIControlEventTouchUpInside];
    [_switchButton addTarget:self action:@selector(setViewForDeckManager) forControlEvents:UIControlEventTouchUpInside];
    
    [_bannerController setTitleWithAnimation:@"Character Store" withColor:[UIColor whiteColor]];
    self.mainView = _storeView;
}

- (void)setMainView:(UIView *)mainView {
    
    if (_mainView) {
        [_mainView removeFromSuperview];
    }
    _mainView = mainView;
    [self.view addSubview:_mainView];
}

@end
