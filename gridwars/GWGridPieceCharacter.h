//
//  GWPieceCharacter.h
//  gridwars
//
//  Created by Hans Arijanto on 11/11/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWGridPiece.h"

@class GWCharacter;

@interface GWGridPieceCharacter : GWGridPiece

@property(nonatomic, strong, readonly)GWCharacter *character;
@property(nonatomic, readwrite)int rotation; // number of 90 degree rotations on area tiles (max 3)
- (void)rotate;

- (instancetype)initWithCharacter:(GWCharacter *)character;
- (NSArray *)movingTileCoordinates; // Coordinates of this characters moving tiles given its current position
- (NSArray *)summoningTileCoordinates; // Coordinates of this characters summoning tiles given its current position
- (NSArray *)summoningTileCoordinatesForAreaView; // Summoning coordinates for GW area view

@end
