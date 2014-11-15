//
//  GWGrid.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGrid.h"
#import "GWGridTile.h"
#import "GWGridPiece.h"
#import "GWGridPieceCharacter.h"

@implementation GWGrid {
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _state = kGWGridStateIdle;
    
    return self;
}

- (void)gridWithNumHorTiles:(NSUInteger)numHorTiles withNumVertTile:(NSUInteger)numVertTiles {
    NSMutableArray *tiles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numHorTiles; i++) {
        NSMutableArray *colTiles = [[NSMutableArray alloc] init];
        for (int j = 0; j < numVertTiles; j++) {
            GWGridTile *tile = [[GWGridTile alloc] initWithSize:_tileSize withCoordinates:CGPointMake(i, j)];
            [colTiles addObject:tile];
        }
        [tiles addObject:(NSArray *)colTiles];
    }
    
    self.tiles = (NSArray *)tiles;
}


- (void)resetAllTileStates {
    for (NSArray *tiles in _tiles) {
        for (GWGridTile *tile in tiles) {
            tile.state = kGWGridStateIdle;
        }
    }
}

- (void)addPiece:(GWGridPiece *)piece {
    GWGridTile *tile = [self tileForRow:piece.row forCol:piece.col];
    
    if (tile) {
        [piece moveTo:CGPointMake(tile.row, tile.col)];
        tile.piece = piece;
    }
}

#pragma mark - moving

- (void)initiateMovingForTile:(GWGridTile *)origin {
    // Set grid state
    _state = kGWGridStateMoving;
    
    // Set current active tile
    _currentMovingTile = origin;
    
    // Set all surrounding tiles as moveable destination
    assert([_currentMovingTile hasCharacter]);
    
    // Set tile states
    NSArray *movingTileCoordinates = ((GWGridPieceCharacter *)_currentMovingTile.piece).movingTileCoordinates;
    for (NSValue *coordinates in movingTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinates.CGPointValue.x forCol:coordinates.CGPointValue.y];
        if (tile) {
            // If tile is empty and is walkable
            if (!tile.piece && tile.walkable) tile.state = kGWTileStateSelectableAsMovingDestination;
        }
    }
    
    _currentMovingTile.state = kGWTileStateSelectableForCancel;
}

- (void)moveToTile:(GWGridTile *)dest {
    // Break if no active tile to move
    assert(_currentMovingTile);
    // Break if current active tile is not a character type
    assert([_currentMovingTile hasCharacter]);
    
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    dest.piece = _currentMovingTile.piece;
    [dest.piece moveTo:CGPointMake(dest.row, dest.col)];
    _currentMovingTile.piece = nil;
    _currentMovingTile = nil;
    
}

- (void)cancelMoving {
    // Break if no active tile to cancel
    assert(_currentMovingTile);
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    _currentMovingTile = nil;
}

#pragma mark - summoning

- (void)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(CGPoint)coordinates {
    assert(_state == kGWGridStateSummoning);
    NSLog(@"Summoned at %i, %i", (int)coordinates.x, (int)coordinates.y);
    // Set characters position on grid
    [characterPiece moveTo:coordinates];
    
    NSArray *summoningTileCoordinates = characterPiece.summoningTileCoordinates;
    
    
    _currentSummoningTile = nil;
    
    //  Make summoning tiles walkable
    for (NSValue *coordinates in summoningTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinates.CGPointValue.x forCol:coordinates.CGPointValue.y];
        tile.walkable = YES;
    }
    
    // Add characters to grid
    [self addPiece:characterPiece];
    
    [self resetAllTileStates];
    _state = kGWGridStateIdle;
}

- (void)initiateSummoningAtCoordinates:(CGPoint)coordinates forCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    assert(_state == kGWGridStateIdle || _state == kGWGridStateSummoning);
    
    GWGridTile *targetSummoningTile = [self tileForRow:coordinates.x forCol:coordinates.y];
    
    assert(targetSummoningTile);
    
    // If target tile has piece return
    if (targetSummoningTile.piece) return;
    
    // If trying to initiate a summon at the same tile return
    if (_currentSummoningTile && _currentSummoningTile.row == (int)coordinates.x && _currentSummoningTile.col == (int)coordinates.y) return;
    
    // Set characters position on grid
    [characterPiece moveTo:coordinates];
    NSArray *summoningTileCoordinates = characterPiece.summoningTileCoordinates;
    
    // Make sure all summoning tiles are empty
    for (NSValue *coordinates in summoningTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinates.CGPointValue.x forCol:coordinates.CGPointValue.y];
        // If tile doesn't exist, has a piece or walkable then cancel summoning
        if (!tile || tile.piece || tile.walkable) {
            [self cancelSummoning];
            return;
        }
    }
    
    // Change all summoning tiles state
    [self resetAllTileStates];
    for (NSValue *coordinates in summoningTileCoordinates) {
        
        GWGridTile *tile = [self tileForRow:coordinates.CGPointValue.x forCol:coordinates.CGPointValue.y];
        tile.state = kGWTileStateSummoning;
    }
    
    _state = kGWGridStateSummoning;
    
    // Set current active tile
    _currentSummoningTile = [self tileForRow:coordinates.x forCol:coordinates.y];

}

- (void)cancelSummoning {
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    _currentSummoningTile = nil;
}

#pragma mark - setter/getter

- (GWGridTile *)tileForRow:(int)row forCol:(int)col {
    if (row < 0 || row >= [self numHorTiles]
        || col < 0 || col >= [self numVertTiles]) return nil;
    return _tiles[row][col];
}

- (NSUInteger)numHorTiles {
    return [_tiles count];
}

- (NSUInteger)numVertTiles {
    return [_tiles[0] count];
}

#pragma mark - helpers

+ (NSArray *)formatCoordinatesForAreaView:(NSArray *)tileCoordinates {
    
    int minX = -1;
    int minY = -1;
    
    for (NSValue *value in tileCoordinates) {
        CGPoint coordinate = value.CGPointValue;
        if (minX == -1 || coordinate.x < minX) minX = coordinate.x;
        if (minY == -1 || coordinate.y < minY) minY = coordinate.y;
    }
    
    NSMutableArray *newTileCoordinates = [[NSMutableArray alloc] init];
    
    for (NSValue *value in tileCoordinates) {
        CGPoint coordinate = value.CGPointValue;
        [newTileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(coordinate.x - minX, coordinate.y - minY)]];
    }
    
    return (NSArray *)newTileCoordinates;
}

@end
