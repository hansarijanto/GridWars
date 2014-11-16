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

@interface GWInfoBoxViewController : UIViewController

@property(nonatomic, strong)GWInfoBoxView *infoBoxView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)clearView;
- (void)setEndTurnBlock:(UIButtonBlock)block;

- (void)setDeckViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece; // Set view for characters in the deck
- (void)setRotateButtonHidden:(BOOL)hidden;

- (void)setGridViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece; // Set view for characters on the grid
- (void)setErrorMessage:(NSString *)errorMessage;

@end
