//
//  GWGridTile.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWGridCoordinate.h"
#import "GWPlayer.h"

@class GWTileContent;
@class GWGridPiece;
@class GWGridPieceCharacter;

typedef enum{
    kGWTileStateIdle,
    kGWTileStateSelectableAsMovingDestination,
    kGWTileStateSelectableAsAttack,
    kGWTileStateSelectableForCancel,
    kGWTileStateSummoning,
} GWTileState;

@interface GWGridTile : GWGridCoordinate

@property(nonatomic)BOOL hidden;
@property(nonatomic)BOOL walkable;
@property(nonatomic, readonly)CGSize size;
@property(nonatomic, strong)GWGridPiece *piece;
@property(nonatomic, readwrite)GWPlayerNumber territory;

@property(nonatomic, readwrite)GWTileState state;

- (instancetype)initWithSize:(CGSize)size withCoordinates:(GWGridCoordinate *)coordinates;
- (BOOL)hasCharacter;

- (GWGridPieceCharacter *)characterPiece;

@end
