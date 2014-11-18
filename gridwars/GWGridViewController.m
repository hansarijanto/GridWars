//
//  GWGridViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-11.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridViewController.h"
#import "GWGameViewController.h"
#import "GWGrid.h"
#import "GWGridPiece.h"
#import "GWGridView.h"
#import "GWGridTile.h"
#import "GWGridPieceCharacter.h"
#import "UIButton+Block.h"

@interface GWGridViewController ()

@end

@implementation GWGridViewController {
    CGPoint _pos;
    GWGridTileOnClick _tileOnClickBlock;
}

- (instancetype)initWithGrid:(GWGrid *)grid atPos:(CGPoint)pos {
    self = [super init];
    if (!self) return nil;
    
    _grid = grid;
    _pos = pos;
    
    float width = _grid.tileSize.width * _grid.numVertTiles;
    float height = _grid.tileSize.height * _grid.numHorTiles;
    
    self.view = [[GWGridView alloc] initWithFrame:CGRectMake(_pos.x, _pos.y, width, height) withGrid:_grid];
    
    NSMutableArray *tileButtons = [[NSMutableArray alloc] init];
    
    // Create tile buttons
    for (int row = 0; row < _grid.numHorTiles; row++) {
        NSMutableArray *tileButtonsCol = [[NSMutableArray alloc] init];
        for (int col = 0; col < _grid.numVertTiles; col++) {
            GWGridTile *tile = _grid.tiles[row][col];
            CGRect tileButtonRect = CGRectMake(tile.col * tile.size.width, tile.row * tile.size.height, tile.size.width, tile.size.height);
            UIButton *tileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tileButton setFrame:tileButtonRect];
            void (^block)(id sender, UIEvent *event) = ^(id sender, UIEvent *event) {
                [self touchForTile:(tile)];
            };
            [tileButton addTarget:self withBlock:block forControlEvents:UIControlEventTouchUpInside];
            [tileButtonsCol addObject:tileButton];
            [self.view addSubview:tileButton];
        }
        [tileButtons addObject:(NSArray *)tileButtonsCol];
    }
    _tileButtons = (NSArray *)tileButtons;
    
    return self;
}

- (GWGridTile *)tileForLocation:(CGPoint)location {

    if (location.x < _pos.x || location.x > _pos.x + self.view.frame.size.width) return nil;
    if (location.y < _pos.y || location.y > _pos.y + self.view.frame.size.height) return nil;
    int col = (location.x - _pos.x) / (int)_grid.tileSize.width;
    int row = (location.y - _pos.y) / (int)_grid.tileSize.height;
    return [_grid tileForRow:row forCol:col];
}

- (void)addPiece:(GWGridPiece *)piece {
    [_grid addPiece:piece];
    [((GWGridView *)self.view) addPiece:piece];
}

#pragma mark - attacking

- (GWGridResponse *)attackCoordinate:(GWGridCoordinate *)coordinate {
    GWGridResponse *response = [_grid attackCoordinate:coordinate];
    [(GWGridView *)self.view updateHealthBarAtCoordinate:coordinate];
    if (response.type == kGWGridResponseTypeCharacterDied) {
        [(GWGridView *)self.view removePieceAtCoordinate:coordinate];
        [self.view setNeedsDisplay];
    }
    return response;
}

# pragma mark - moving

- (void)moveToCoordinate:(GWGridCoordinate *)coordinate {
    
    GWGridTile *tile = [_grid tileForRow:coordinate.row forCol:coordinate.col];
    
    [((GWGridView *)self.view) movePice:_grid.currentActionTile.piece to:tile fadeOut:NO];
    // Move tile on grid
    [_grid moveToCoordinate:coordinate];
}

- (GWGridResponse *)initiateActionAtCoordinates:(GWGridCoordinate *)coordinate {
    return [_grid initiateActionAtCoordinates:coordinate];
}

- (void)cancelAction {
    [_grid cancelAction];
}

#pragma mark - summoning

- (void)initiateSummoningAtCoordinates:(GWGridCoordinate *)coordinates forCharacterPiece:(GWGridPieceCharacter *)characterPiece; {
    [_grid initiateSummoningAtCoordinates:coordinates forCharacterPiece:characterPiece];
    [self.view setNeedsDisplay];
}

- (void)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(GWGridCoordinate *)coordinates {
    [_grid summonCharacter:characterPiece atCoordinates:coordinates];
    [self addPiece:characterPiece];
    [self.view setNeedsDisplay];
}

- (void)cancelSummoning {
    [_grid cancelSummoning];
    [self.view setNeedsDisplay];
}

# pragma mark - callbacks

- (void)endTurn {
    NSLog(@"End Turn");
    [_grid endTurn];
    [self.view setNeedsDisplay];
}

- (void)setTileOnClickBlock:(GWGridTileOnClick)block {
    _tileOnClickBlock = block;
}

// Called when a tile is touched on the grid
- (void)touchForTile:(GWGridTile *)tile {
    NSLog(@"Touch grid at: %d, %d", tile.row, tile.col);
    if(_tileOnClickBlock) _tileOnClickBlock(tile);
    [self.view setNeedsDisplay];
}

@end
