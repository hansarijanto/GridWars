//
//  GWGrid.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWGridResponse.h"

@class GWGridTile;
@class GWGridPiece;
@class GWGridPieceCharacter;
@class GWGridCoordinate;

@interface GWGrid : NSObject

typedef enum{
    kGWGridStateIdle, // When nothing is happening
    kGWGridStateAction, // When a character is selected for action (moving, attacking)
    kGWGridStateSummoning, // When summoning a character
} GWGridState;

@property(nonatomic, strong)NSArray *tiles; // 2D array of tiles[row][col]
@property(nonatomic, readwrite)CGSize tileSize; // Size of each tile
@property(nonatomic, readwrite)GWGridState state; // Size of each tile
@property(nonatomic, readonly)NSUInteger numHorTiles;
@property(nonatomic, readonly)NSUInteger numVertTiles;
@property(nonatomic, strong, readonly)GWGridTile *currentActionTile;
@property(nonatomic, strong, readonly)GWGridTile *currentSummoningTile;

- (GWGridTile *)tileForRow:(int)row forCol:(int)col;
- (void)gridWithNumHorTiles:(NSUInteger)numHorTiles withNumVertTile:(NSUInteger)numVertTiles;

// Actions
- (GWGridResponse *)attackCoordinate:(GWGridCoordinate *)coordinate;
- (GWGridResponse *)initiateActionAtCoordinates:(GWGridCoordinate *)coordinate;
- (void)moveToCoordinate:(GWGridCoordinate *)coordinate;
- (void)cancelAction;

// Summoning
- (void)initiateSummoningAtCoordinates:(GWGridCoordinate *)coordinates forCharacterPiece:(GWGridPieceCharacter *)characterPiece;
- (void)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(GWGridCoordinate *)coordinates;
- (void)cancelSummoning;

- (NSArray *)allCharacterPieces;
- (void)endTurn;
- (void)addPiece:(GWGridPiece *)piece;
@end
