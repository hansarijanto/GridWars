//
//  GWGridViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-11.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGrid;
@class GWGridResponse;
@class GWGridTile;
@class GWGridPiece;
@class GWGridPieceCharacter;
@class GWGridCoordinate;
@class GWPlayer;

typedef void (^GWGridTileOnClick) (GWGridTile *tile);

@interface GWGridViewController : UIViewController

- (instancetype)initWithGrid:(GWGrid *)grid atPos:(CGPoint)pos;
- (void)setTileOnClickBlock:(GWGridTileOnClick)block;
- (void)addPiece:(GWGridPiece *)piece; // Adding a piece to the grid
- (void)addLeaderPiece:(GWGridPieceCharacter *)characterPiece; // Adding a character piece to the grid while taking over territory
- (GWGridTile *)tileForLocation:(CGPoint)location; // Return grid tile based on location on screen
- (CGPoint)locationForTile:(GWGridTile *)tile; // Return grid tile based on location on screen

// Claiming Territory
- (void)claimTerritoriesForPlayer:(GWPlayer *)player; // Execute territory claiming of all player's active characters on the grid
- (void)claimTerritoryForCharacterPiece:(GWGridPieceCharacter *)characterPiece; // Claims territory for a character piece

// Summoning
- (void)initiateSummoningAtCoordinates:(GWGridCoordinate *)coordinates forCharacterPiece:(GWGridPieceCharacter *)characterPiece; // When a character wants to start summoning
- (void)cancelSummoning; // When a character wants to stop summoning
- (void)summonCharacter:(GWGridPieceCharacter *)characterPiece atCoordinates:(GWGridCoordinate *)coordinates; // Summon a character on a coordinate

// Action
- (GWGridResponse *)attackCoordinate:(GWGridCoordinate *)coordinate;
- (GWGridResponse *)initiateActionAtCoordinates:(GWGridCoordinate *)coordinate withPlayer:(GWPlayer *)player; // When a character wants to start moving on the grid
- (void)moveToCoordinate:(GWGridCoordinate *)coordinate;
- (void)cancelAction; // When a character wants to stop moving on the grid

// End
- (void)endTurn:(GWPlayer *)player;

@property(nonatomic, strong)NSArray *tileButtons;
@property(nonatomic, strong, readonly)GWGrid *grid;

@end
