//
//  GWGridView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridView.h"
#import "GWGrid.h"
#import "GWCharacter.h"
#import "GWGridPieceCharacter.h"
#import "GWGridTile.h"
#import "UIButton+Block.h"
#import "GWGridTileView.h"
#import "GWGridPieceCharacterView.h"

@implementation GWGridView {
}

- (instancetype)initWithFrame:(CGRect)frame withGrid:(GWGrid *)grid
{
    self = [super initWithFrame:frame];
    if (!self) nil;
    
    _grid = grid;
    
    NSMutableArray *tileViews = [[NSMutableArray alloc] init];
    NSMutableArray *pieceViews = [[NSMutableArray alloc] init];
    
    for (int row = 0; row < _grid.numHorTiles; row++) {
        NSMutableArray *tileViewsCol = [[NSMutableArray alloc] init];
        NSMutableArray *pieceViewsCol = [[NSMutableArray alloc] init];
        for (int col = 0; col < _grid.numVertTiles; col++) {
            // Add tile ui
            GWGridTile *tile = _grid.tiles[row][col];
            CGRect tileRect = CGRectMake(tile.col * tile.size.width,tile.row * tile.size.height, tile.size.width, tile.size.height);
            
            GWGridTileView *tileView = [[GWGridTileView alloc] initWithFrame:tileRect withTile:tile];
            [self addSubview:tileView];
            [tileViewsCol addObject:tileView];
            [pieceViewsCol addObject:[NSNull null]];
        }
        [pieceViews addObject:(NSArray *)pieceViewsCol];
        [tileViews addObject:(NSArray *)tileViewsCol];
    }
    
    _pieceViews = (NSArray *)pieceViews;
    _tileViews = (NSArray *)tileViews;
    
    return self;
}

- (void)removePieceAtCoordinate:(GWGridCoordinate *)coordinate {
    GWGridPieceView *pieceView = _pieceViews[coordinate.row][coordinate.col];
    
    __weak GWGridPieceView *weak = pieceView;
    
    if ([pieceView isMemberOfClass:[GWGridPieceCharacterView class]]) {
        [(GWGridPieceCharacterView *)pieceView runDyingAnimationWithCompletionBlock:^{
            GWGridPieceView *strong = weak;            
            [strong removeFromSuperview];
        }];
    }
    _pieceViews[coordinate.row][coordinate.col] = [NSNull null];
}

- (void)addPiece:(GWGridPiece *)piece {
    NSMutableArray *pieces = [_pieceViews mutableCopy];
    GWGridTile *tile = _grid.tiles[piece.row][piece.col];
    CGRect tileRect = CGRectMake(tile.col * tile.size.width,tile.row * tile.size.height, tile.size.width, tile.size.height);
    
    if ([piece isCharacter]) {
        GWGridPieceCharacterView *pieceView = [[GWGridPieceCharacterView alloc] initWithFrame:tileRect withCharacterPiece:(GWGridPieceCharacter *)piece];
        [self addSubview:pieceView];

        pieces[piece.row][piece.col] = pieceView;
        
    }
    
    _pieceViews = (NSArray *)pieces;
}

#pragma mark - GWGridPieceCharacterView

- (void)updateHealthBarAtCoordinate:(GWGridCoordinate *)coordinate {
    GWGridPieceView *pieceView = _pieceViews[coordinate.row][coordinate.col];
    assert([pieceView isMemberOfClass:[GWGridPieceCharacterView class]]);
    [((GWGridPieceCharacterView *)pieceView) updateHealthBarUI];
}

- (void)movePice:(GWGridPiece *)piece to:(GWGridTile *)tile fadeOut:(BOOL)fadeOut {
    GWGridPieceView *pieceView = _pieceViews[piece.row][piece.col];
    
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5f animations:^(void){
                pieceView.alpha = 0.5f;
            }];
        }
    };
    
    if (!fadeOut) completion = nil;

    CGRect tileRect = CGRectMake(tile.col * tile.size.width,tile.row * tile.size.height, tile.size.width, tile.size.height);
    [UIView animateWithDuration:1.0f animations:^(void){
        pieceView.frame = tileRect;
    } completion:completion];
    
    _pieceViews[tile.row][tile.col] = pieceView;
    _pieceViews[piece.row][piece.col] = [NSNull null];
}

- (void)setNeedsDisplay {
    for (NSArray *tiles in _tileViews) {
        for (GWGridTileView *tileView in tiles) {
            [tileView setNeedsDisplay];
        }
    }
    
    for (NSArray *pieceViews in _pieceViews) {
        for (GWGridPieceView *pieceView in pieceViews) {
            if(![pieceView isEqual:[NSNull null]]) [pieceView setNeedsDisplay];
        }
    }
}

@end
