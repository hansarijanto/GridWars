//
//  GWGridInfoBoxCharacterView.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWInfoBoxView.h"

@class GWGridPieceCharacter;
@class GWAreaView;

@interface GWInfoBoxCharacterView : GWInfoBoxView

@property(nonatomic, strong)GWAreaView *areaView;
@property(nonatomic, strong)UIButton *rotateButton;

- (id)initWithFrame:(CGRect)frame withCharacterPiece:(GWGridPieceCharacter *)characterPiece;

@end
