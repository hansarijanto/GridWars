//
//  GWDeckCell.h
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGWDeckCellTypeCharacter,
} GWDeckCellType;

@class GWCharacter;
@class GWGridPieceCharacter;

@interface GWDeckCell : NSObject

- (instancetype)initWithCharacter:(GWCharacter *)character;

@property(nonatomic, strong, readonly)GWCharacter *character;
@property(nonatomic, readonly)GWDeckCellType type;
@property(nonatomic, readonly)GWGridPieceCharacter *characterPiece;
@end
