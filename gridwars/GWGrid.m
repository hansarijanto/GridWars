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
#import "GWCharacter.h"

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
    
    for (int i = 0; i < numVertTiles; i++) {
        NSMutableArray *colTiles = [[NSMutableArray alloc] init];
        for (int j = 0; j < numHorTiles; j++) {
            GWGridTile *tile = [[GWGridTile alloc] initWithSize:_tileSize withCoordinates:[[GWGridCoordinate alloc] initWithRow:i withCol:j]];
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
        [piece moveTo:[[GWGridCoordinate alloc] initWithRow:tile.row withCol:tile.col]];
        tile.piece = piece;
    }
}

- (void)endTurn {
    for (GWGridPieceCharacter *characterPiece in self.allCharacterPieces) {
        [characterPiece.character resetMoves];
    
    }
    [self resetAllTileStates];
    _state = kGWGridStateIdle;
}

#pragma mark - moving

- (GWGridResponse *)initiateMovingAtCoordinates:(GWGridCoordinate *)coordinate {
    
    GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
    GWGridPieceCharacter *characterPiece = [tile getCharacterPiece];
    
    // Check if tile exist and has character
    assert(tile && characterPiece);
    
    // Check to see if character has any moves left
    if (characterPiece.character.moves <= 0) {
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"Character has no moves left"];
    }
    
    // Set grid state
    _state = kGWGridStateMoving;
    
    // Set current active tile
    _currentMovingTile = tile;
    
    // Set tile states
    NSArray *movingTileCoordinates = ((GWGridPieceCharacter *)_currentMovingTile.piece).movingTileCoordinates;
    for (GWGridCoordinate *coordinate in movingTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        if (tile) {
            // If tile is empty and is walkable
            if (!tile.piece && tile.walkable) tile.state = kGWTileStateSelectableAsMovingDestination;
        }
    }
    
    _currentMovingTile.state = kGWTileStateSelectableForCancel;
    return [[GWGridResponse alloc] initWithSuccess:YES withMessage:@"Successfully initiated move for character"];
}

- (void)moveToCoordinate:(GWGridCoordinate *)coordinate {
    
    GWGridTile *destTile = [self tileForRow:coordinate.row forCol:coordinate.col];
    
    // make sure destination tile exist
    assert(destTile);
    
    GWGridPieceCharacter *characterPiece = [_currentMovingTile getCharacterPiece];

    // Break if no active tile to move or tile has no character
    assert(_currentMovingTile && characterPiece);

    // Decrement character move count
    [characterPiece.character moved];
    
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    destTile.piece = _currentMovingTile.piece;
    [destTile.piece moveTo:[[GWGridCoordinate alloc] initWithRow:destTile.row withCol:destTile.col]];
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

- (void)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(GWGridCoordinate *)coordinates {
    assert(_state == kGWGridStateSummoning);
    NSLog(@"Summoned at %i, %i", coordinates.row, coordinates.col);
    // Set characters position on grid
    [characterPiece moveTo:coordinates];
    
    NSArray *summoningTileCoordinates = characterPiece.summoningTileCoordinates;
    
    
    _currentSummoningTile = nil;
    
    //  Make summoning tiles walkable
    for (GWGridCoordinate *coordinate in summoningTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        tile.walkable = YES;
    }
    
    // Add characters to grid
    [self addPiece:characterPiece];
    
    [self resetAllTileStates];
    _state = kGWGridStateIdle;
}

- (void)initiateSummoningAtCoordinates:(GWGridCoordinate *)coordinates forCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    assert(_state == kGWGridStateIdle || _state == kGWGridStateSummoning);
    
    GWGridTile *targetSummoningTile = [self tileForRow:coordinates.row forCol:coordinates.col];
    
    assert(targetSummoningTile);
    
    // If target tile has piece return
    if (targetSummoningTile.piece) return;
    
    // If trying to initiate a summon at the same tile return
    if (_currentSummoningTile && _currentSummoningTile.row == (int)coordinates.row && _currentSummoningTile.col == (int)coordinates.col) return;
    
    // Set characters position on grid
    [characterPiece moveTo:coordinates];
    NSArray *summoningTileCoordinates = characterPiece.summoningTileCoordinates;
    // Make sure all summoning tiles are empty
    for (GWGridCoordinate *coordinate in summoningTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        // If tile doesn't exist, has a piece or walkable then cancel summoning
        if (!tile || tile.piece || tile.walkable) {
            [self cancelSummoning];
            return;
        }
    }
    
    // Change all summoning tiles state
    [self resetAllTileStates];
    for (GWGridCoordinate *coordinate in summoningTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        tile.state = kGWTileStateSummoning;
    }
    
    _state = kGWGridStateSummoning;
    
    // Set current active tile
    _currentSummoningTile = [self tileForRow:coordinates.row forCol:coordinates.col];

}

- (void)cancelSummoning {
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    _currentSummoningTile = nil;
}

#pragma mark - setter/getter

- (NSArray *)allCharacterPieces {
    NSMutableArray *characterPieces = [[NSMutableArray alloc] init];
    for (NSArray *tiles in _tiles) {
        for (GWGridTile *tile in tiles) {
            if ([tile hasCharacter]) [characterPieces addObject:[tile getCharacterPiece]];
        }
    }
    return characterPieces;
}

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

@end
