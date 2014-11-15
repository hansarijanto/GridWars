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

- (void)movePice:(GWGridPiece *)piece to:(GWGridTile *)tile {
    GWGridPieceView *pieceView = _pieceViews[piece.row][piece.col];

    CGRect tileRect = CGRectMake(tile.col * tile.size.width,tile.row * tile.size.height, tile.size.width, tile.size.height);
    [UIView animateWithDuration:1.0f animations:^(void){
        pieceView.frame = tileRect;
    }];
    
    _pieceViews[tile.row][tile.col] = pieceView;
    _pieceViews[piece.row][piece.col] = [NSNull null];
}

- (void)setNeedsDisplay {
    for (NSArray *tiles in _tileViews) {
        for (GWGridTileView *tileView in tiles) {
            [tileView setNeedsDisplay];
        }
    }
}

@end
