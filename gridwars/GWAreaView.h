//
//  GWAreaView.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGridPieceCharacter;

@interface GWAreaView : UIView

@property(nonatomic, strong)NSArray *coordinates;
@property(nonatomic, strong)GWGridPieceCharacter *characterPiece;

@end
