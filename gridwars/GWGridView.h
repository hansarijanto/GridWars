//
//  GWGridView.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGrid;
@class GWGridPiece;
@class GWGridTile;

@interface GWGridView : UIView

@property(nonatomic, strong)GWGrid *grid;
@property(nonatomic, strong)NSArray *tileViews; // 2d tileViews[row][col]
@property(nonatomic, strong)NSArray *pieceViews; // 2d pieceViews[row][col]

- (instancetype)initWithFrame:(CGRect)frame withGrid:(GWGrid *)grid;
- (void)addPiece:(GWGridPiece *)piece;
- (void)movePice:(GWGridPiece *)piece to:(GWGridTile *)tile fadeOut:(BOOL)fadeOut;

@end
