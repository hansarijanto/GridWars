//
//  GWGridPieceCharacterView.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-13.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWGridPieceView.h"

@class GWGridPieceCharacter;

@interface GWGridPieceCharacterView : GWGridPieceView

@property(nonatomic, strong, readonly)GWGridPieceCharacter *characterPiece;

- (id)initWithFrame:(CGRect)frame withCharacterPiece:(GWGridPieceCharacter *)characterPiece;
- (void)updateHealthBarUI;

@end
