//
//  GWGridInfoBoxViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGridPieceCharacter;

@interface GWInfoBoxViewController : UIViewController

- (void)setViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece;
- (void)clearView;
- (void)reloadData;
- (void)setRotateButtonHidden:(BOOL)hidden;

@end
