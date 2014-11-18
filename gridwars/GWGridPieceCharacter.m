//
//  GWPieceCharacter.m
//  gridwars
//
//  Created by Hans Arijanto on 11/11/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWGridPieceCharacter.h"
#import "GWCharacter.h"
#import "GWGrid.h"

@implementation GWGridPieceCharacter {
}

- (instancetype)initWithCharacter:(GWCharacter *)character {
    self = [super init];
    if (!self) return nil;
    
    _rotation = 0;
    _character = character;
    
    return self;
}

// Rotate 90 degress clockwise
- (void)rotate {
    if (_rotation == 3) _rotation = 0;
    else _rotation++;
}

// Rotate clockwise
- (GWGridCoordinate *)rotate:(GWGridCoordinate *)coordinate withCenterCoordinate:(GWGridCoordinate *)center angle:(CGFloat)angle {
    CGPoint offsetFromCenter = CGPointMake(coordinate.col - center.col, coordinate.row - center.row);
    CGPoint rotatedOffset = CGPointApplyAffineTransform(offsetFromCenter, CGAffineTransformMakeRotation(angle));
    return [[GWGridCoordinate alloc] initWithRow:(center.row + rotatedOffset.y) withCol:(center.col + rotatedOffset.x)];
}

- (NSArray *)movingTileCoordinates {
    return [self areaTileCoordinates:_character.moveType withOriginCoordinate:[[GWGridCoordinate alloc] initWithRow:self.row withCol:self.col]];
}

- (NSArray *)attackingTileCoordinates {
    return [self areaTileCoordinates:_character.attackType withOriginCoordinate:[[GWGridCoordinate alloc] initWithRow:self.row withCol:self.col]];
}

- (NSArray *)summoningTileCoordinates {
    return [self areaTileCoordinates:_character.summonType withOriginCoordinate:[[GWGridCoordinate alloc] initWithRow:self.row withCol:self.col]];
}

- (NSArray *)summoningTileCoordinatesForAreaView {
    return [self areaTileCoordinates:_character.summonType withOriginCoordinate:[[GWGridCoordinate alloc] initWithRow:0 withCol:0]];
}

// Return coordinates of tiles given an area type and a character's current position
- (NSArray *)areaTileCoordinates:(GWAreaType)type withOriginCoordinate:(GWGridCoordinate *)origin {
    
    NSMutableArray *tileCoordinates = [[NSMutableArray alloc] init];
    
    switch (type) {
        case kGWAreaType3x3Square:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col - 1]];
            break;
        case kGWAreaTypeCross:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 1]];
            break;
        case kGWAreaTypeLargeCross:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 2 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 2 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 2]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 2]];
            break;
        case kGWAreaTypeSquareCross:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 2 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 2 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 2]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 2]];
            break;
        case kGWAreaTypeLine1:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            break;
        case kGWAreaTypeLine2:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            break;
        case kGWAreaTypeLine3:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col]];
            break;
        case kGWAreaTypeDiagonal:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col + 1]];
            break;
        case kGWAreaTypeLeftSquigly:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 1]];
            break;
        case kGWAreaTypeRightSquigly:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row - 1 withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 1]];
            break;
        case kGWAreaTypeT:
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col + 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col - 1]];
            [tileCoordinates addObject:[[GWGridCoordinate alloc] initWithRow:origin.row + 1 withCol:origin.col]];
            break;
        default:
            break;
    }
    
    // Rotating coordinates
    if (_rotation > 0) {
        for (int i=0; i<[tileCoordinates count]; i++) {
            GWGridCoordinate *tileCoordinate = tileCoordinates[i];
            
            // Rotate accordingly
            tileCoordinate = [self rotate:tileCoordinate withCenterCoordinate:[[GWGridCoordinate alloc] initWithRow:origin.row withCol:origin.col] angle:_rotation * M_PI / 2];
            
            // Set new rotated value
            tileCoordinates[i] = tileCoordinate;
        }
    }
    
    return (NSArray *)tileCoordinates;
}

@end
