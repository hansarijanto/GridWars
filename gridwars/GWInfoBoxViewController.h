//
//  GWGridInfoBoxViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

@class GWGridPieceCharacter;
@class GWInfoBoxView;
@class GWPlayer;
@class GWCharacter;

@interface GWInfoBoxViewController : UIViewController

@property(nonatomic, strong)GWInfoBoxView *infoBoxView;
@property(nonatomic, readonly)UIButton *button; // Button at bottom center of info box, by default its hidden

- (instancetype)initWithFrame:(CGRect)frame;
- (void)clearView;

- (void)setViewForDeckWithCharacterPiece:(GWGridPieceCharacter *)characterPiece; // Set view for characters in the deck
- (void)setRotateButtonHidden:(BOOL)hidden;

- (void)setViewForGridWithCharacterPiece:(GWGridPieceCharacter *)characterPiece withClaimBlock:(UIButtonBlock)block withPlayer:(GWPlayer *)player; // Set view for characters on the grid
- (void)setErrorMessage:(NSString *)errorMessage;

- (void)setViewForStoreWithCharacter:(GWCharacter *)character;

@end
