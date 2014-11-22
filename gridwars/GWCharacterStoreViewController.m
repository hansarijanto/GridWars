//
//  GWCharacterStoreViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCharacterStoreViewController.h"
#import "GWInfoBoxViewController.h"
#import "GWPlayer.h"
#import "GWCharacter.h"
#import "GWCharacterStoreCellView.h"
#import "UIButton+Block.h"

@interface GWCharacterStoreViewController ()

@end

@implementation GWCharacterStoreViewController {
    CGFloat _vertOffset;
    CGFloat _horOffset;
    CGFloat _horCellSpacing;
    CGFloat _vertCellSpacing;
    CGFloat _cellWidth;
    CGFloat _cellHeight;
    GWPlayer *_player;
    GWInfoBoxViewController *_infoBoxController;
}

- (instancetype)initWithPlayer:(GWPlayer *)player {
    self = [super init];
    if (!self) return nil;
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 600.f)];
    
    _player = player;
    
    _vertOffset = 10.0f;
    _horOffset  = 10.0f;
    _horCellSpacing  = 10.0f;
    _vertCellSpacing = 10.0f;
    _cellWidth  = 67.5f;
    _cellHeight = 100.0f;
    
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    
    // Create characters
    GWCharacter *warrior = [[GWCharacter alloc] initWithType:kGWCharacterTypeWarrior];
    GWCharacter *thief   = [[GWCharacter alloc] initWithType:kGWCharacterTypeThief];
    GWCharacter *priest  = [[GWCharacter alloc] initWithType:kGWCharacterTypePriest];
    GWCharacter *archer  = [[GWCharacter alloc] initWithType:kGWCharacterTypeArcher];
    GWCharacter *mage    = [[GWCharacter alloc] initWithType:kGWCharacterTypeMage];
    
    // Add to characters
    [characters addObject:warrior];
    [characters addObject:thief];
    [characters addObject:priest];
    [characters addObject:archer];
    [characters addObject:mage];
    
    _infoBoxController = [[GWInfoBoxViewController alloc] initWithFrame:CGRectMake(10.0f, 470.0f, 300.0f, 90.0f)];
    [self addChildViewController:_infoBoxController];
    [self.view addSubview:_infoBoxController.view];
    
    // Create store cell views
    for (int i=0; i<[characters count]; ++i) {
        GWCharacter *character = characters[i];
        
         // 4 cols per row
        int row = i / 4;
        int col = i % 4;
        
        GWCharacterStoreCellView *storeCell = [[GWCharacterStoreCellView alloc] initWithFrame:CGRectMake(_horOffset + col * (_horCellSpacing + _cellWidth), _vertOffset + row * (_cellHeight + _vertCellSpacing), _cellWidth, _cellHeight) withCharacter:character];
        
        __weak GWCharacter *weakCharacter = character;
        __weak GWPlayer *weakPlayer = _player;
        
        // Add character to player when bought
        UIButtonBlock buyButtonBlock = ^(id sender, UIEvent *event) {
            GWCharacter *strongCharacter = weakCharacter;
            GWPlayer *strongPlayer = weakPlayer;
    
            [strongPlayer addCharacter:strongCharacter];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchased!"
                                                            message:[NSString stringWithFormat:@"You got a %@", strongCharacter.characterClass]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        };
        
        [storeCell.buyButton addTarget:self withBlock:buyButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        // Show character info when store cell is pressed
        __weak GWInfoBoxViewController *weakInfoBox = _infoBoxController;
        UIButtonBlock cellButtonBlock = ^(id sender, UIEvent *event) {
            GWInfoBoxViewController *infoBox = weakInfoBox;
            GWCharacter *strongCharacter = weakCharacter;
            
            [infoBox setViewForStoreWithCharacter:strongCharacter];
        };
        [storeCell addTarget:self withBlock:cellButtonBlock forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:storeCell];
    }
    
    return self;
}

@end
