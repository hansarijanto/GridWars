//
//  GWInfoBoxGridCharacterView.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-16.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWInfoBoxView.h"

@class GWGridPieceCharacter;
@class GWAreaView;

@interface GWInfoBoxGridCharacterView : GWInfoBoxView

@property(nonatomic, strong)UITextView *errorMessage;
@property(nonatomic, strong)UIButton *claimButton;

- (id)initWithFrame:(CGRect)frame withCharacterPiece:(GWGridPieceCharacter *)characterPiece;

@end
