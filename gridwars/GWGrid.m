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
#import "GWPlayer.h"

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

- (void)endTurn:(GWPlayer *)player {
    for (GWGridPieceCharacter *characterPiece in self.allCharacterPieces) {
        // Reset opposing player's characters
        if (characterPiece.owner.playerNumber != player.playerNumber) {
            [characterPiece.character resetMoves];
        }
    }
    [self resetAllTileStates];
    _state = kGWGridStateIdle;
}

#pragma mark - actions

- (GWGridResponse *)attackCoordinate:(GWGridCoordinate *)coordinate {
    assert(_state == kGWGridStateAction && _currentActionTile);
    
    GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
    
    // Make sure attacked tile exist
    assert(tile);
    
    GWGridPieceCharacter *damagedPiece = [tile characterPiece];
    GWGridPieceCharacter *attackingPiece = [_currentActionTile characterPiece];
    
    // Make sure both characters in the battle exist
    assert(attackingPiece && damagedPiece);
    
    [damagedPiece.character damagedBy:attackingPiece.character];
    
    // Decrement character move count
    [attackingPiece.character decrementActions];
    
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    _currentActionTile = nil;
    
    //Check if damaged piece died
    if (damagedPiece.character.health <= 0) {
        tile.piece = nil;
        return [[GWGridResponse alloc] initWithSuccess:YES withMessage:@"Character Died" withStatus:kGWGridResponseTypeCharacterDied];
    } else {
        return [[GWGridResponse alloc] initWithSuccess:YES withMessage:@"Successfully attacked character" withStatus:kGWGridResponseTypeUknown];
    }
}

- (GWGridResponse *)initiateActionAtCoordinates:(GWGridCoordinate *)coordinate withPlayer:(GWPlayer *)player {
    
    GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
    GWGridPieceCharacter *characterPiece = tile.characterPiece;
    
    // Check if tile exist and has character
    assert(tile && characterPiece);
    
    // Check to see if its the character's turn
    if (player.playerNumber != characterPiece.owner.playerNumber) {
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"Its not that character's turn" withStatus:kGWGridResponseTypeActionNotCharacterTurn];
    }
    
    // Check to see if character has any moves left
    if (characterPiece.character.actions <= 0) {
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"Character has no moves left to intiate action" withStatus:kGWGridResponseTypeActionNoMovesLeft];
    }
    
    // Check to see if character is currently claiming territory
    if (characterPiece.state == kGWGridPieceCharacterStateClaimingTerritory) {
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"Character is claiming territory" withStatus:kGWGridResponseTypeActionClaimingTerritory];
    }
    
    // Set grid state
    _state = kGWGridStateAction;
    
    // Set current active tile
    _currentActionTile = tile;
    
    // Set tile states for moving
    NSArray *movingTileCoordinates = ((GWGridPieceCharacter *)_currentActionTile.piece).movingTileCoordinates;
    for (GWGridCoordinate *coordinate in movingTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        if (tile) {
            // If tile is empty and is walkable
            if (!tile.piece && tile.walkable) tile.state = kGWTileStateSelectableAsMovingDestination;
        }
    }
    
    // Set tile states for attacking
    NSArray *attackingTileCoordinates = ((GWGridPieceCharacter *)_currentActionTile.piece).attackingTileCoordinates;
    for (GWGridCoordinate *coordinate in attackingTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        if (tile) {
            // If tile has a character
            if ([tile hasCharacter]) {
                // If both charaters have the same owner, don't allow attack
                if (tile.characterPiece.owner.playerNumber == _currentActionTile.characterPiece.owner.playerNumber) continue;
                tile.state = kGWTileStateSelectableAsAttack;
            }
        }
    }
    
    _currentActionTile.state = kGWTileStateSelectableForCancel;
    return [[GWGridResponse alloc] initWithSuccess:YES withMessage:@"Successfully initiated action for character" withStatus:kGWGridResponseTypeUknown];
}

- (void)moveToCoordinate:(GWGridCoordinate *)coordinate {
    
    assert(_state == kGWGridStateAction && _currentActionTile);
    
    GWGridTile *destTile = [self tileForRow:coordinate.row forCol:coordinate.col];
    
    // make sure destination tile exist
    assert(destTile);
    
    GWGridPieceCharacter *characterPiece = [_currentActionTile characterPiece];

    // Break if tile has no character
    assert(characterPiece);

    // Decrement character move count
    [characterPiece.character decrementActions];
    
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    destTile.piece = _currentActionTile.piece;
    [destTile.piece moveTo:[[GWGridCoordinate alloc] initWithRow:destTile.row withCol:destTile.col]];
    _currentActionTile.piece = nil;
    _currentActionTile = nil;
}

- (void)cancelAction {
    // Break if no active tile to cancel
    assert(_currentActionTile);
    // Reset grid and tile states
    _state = kGWGridStateIdle;
    [self resetAllTileStates];
    
    _currentActionTile = nil;
}

#pragma mark - summoning

- (GWGridResponse *)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(GWGridCoordinate *)coordinates withPlayer:(GWPlayer *)player {
    
    assert(_state == kGWGridStateSummoning);
    
    // Cancel if its not the player's turn
    if (characterPiece.owner.playerNumber != player.playerNumber) {
        [self cancelSummoning];
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"You can only summon on your turn" withStatus:kGWGridResponseTypeSummonNotCharacterTurn];
    }
    
    GWGridTile *summoningTile = [self tileForRow:coordinates.row forCol:coordinates.col];
    // Cancel if summoning on an opponents territory
    if (summoningTile.territory != characterPiece.owner.playerNumber) {
        [self cancelSummoning];
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"You must summon on your territory" withStatus:kGWGridResponseTypeSummonOutsideTerritory];
    }
    
    if (summoningTile.piece) {
        [self cancelSummoning];
        return [[GWGridResponse alloc] initWithSuccess:NO withMessage:@"You must summon on an empty tile" withStatus:kGWGridResponseTypeSummonOnFilledTile];
    }
    
    NSLog(@"Summoned at %i, %i", coordinates.row, coordinates.col);
    // Set characters position on grid
    [characterPiece moveTo:coordinates];
    
    // Add characters to grid
    [self addPiece:characterPiece];
    
    // Clean up
    [self cancelSummoning];
    
    return [[GWGridResponse alloc] initWithSuccess:YES withMessage:@"Successfully summoned character" withStatus:kGWGridResponseTypeSummonSuccessful];
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
    // Make sure all summoning tiles within the territory
    for (GWGridCoordinate *coordinate in summoningTileCoordinates) {
        GWGridTile *tile = [self tileForRow:coordinate.row forCol:coordinate.col];
        // If tile doesn't exist, has a piece or walkable then cancel summoning
        if (!tile || tile.piece) {
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
            if ([tile hasCharacter]) [characterPieces addObject:[tile characterPiece]];
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
