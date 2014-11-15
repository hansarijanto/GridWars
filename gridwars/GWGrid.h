//
//  GWGrid.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GWGridTile;
@class GWGridPiece;
@class GWGridPieceCharacter;

@interface GWGrid : NSObject

typedef enum{
    kGWGridStateIdle, // When nothing is happening
    kGWGridStateMoving, // When a character is moving
    kGWGridStateSummoning, // When summoning a character
} GWGridState;

@property(nonatomic, strong)NSArray *tiles; // 2D array of tiles[row][col]
@property(nonatomic, readwrite)CGSize tileSize; // Size of each tile
@property(nonatomic, readwrite)GWGridState state; // Size of each tile
@property(nonatomic, readonly)NSUInteger numHorTiles;
@property(nonatomic, readonly)NSUInteger numVertTiles;
@property(nonatomic, strong, readonly)GWGridTile *currentMovingTile;
@property(nonatomic, strong, readonly)GWGridTile *currentSummoningTile;

- (GWGridTile *)tileForRow:(int)row forCol:(int)col;
- (void)gridWithNumHorTiles:(NSUInteger)numHorTiles withNumVertTile:(NSUInteger)numVertTiles;

// Moving
- (void)initiateMovingForTile:(GWGridTile *)origin;
- (void)moveToTile:(GWGridTile *)dest;
- (void)cancelMoving;

// Summoning
- (void)initiateSummoningAtCoordinates:(CGPoint)coordinates forCharacterPiece:(GWGridPieceCharacter *)characterPiece;
- (void)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(CGPoint)coordinates;
- (void)cancelSummoning;

- (void)addPiece:(GWGridPiece *)piece;

// Helpers
+ (NSArray *)formatCoordinatesForAreaView:(NSArray *)tileCoordinates; // Converts a set of coordinates to a 3 x 3 grid set of coordinates
@end
