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
- (CGPoint)rotate:(CGPoint)coordinates angle:(CGFloat)angle {
    CGPoint offsetFromCenter = CGPointMake(coordinates.y - self.col, coordinates.x - self.row);
    CGPoint rotatedOffset = CGPointApplyAffineTransform(offsetFromCenter, CGAffineTransformMakeRotation(-angle));
    return CGPointMake(self.row + rotatedOffset.y, self.col + rotatedOffset.x);
}

- (NSArray *)movingTileCoordinates {
    return [self areaTileCoordinates:_character.moveType withOriginCoordinate:CGPointMake(self.row, self.col)];
}

- (NSArray *)summoningTileCoordinates {
    return [self areaTileCoordinates:_character.summonType withOriginCoordinate:CGPointMake(self.row, self.col)];
}

- (NSArray *)summoningTileCoordinatesForAreaView {
    return [GWGrid formatCoordinatesForAreaView:[self areaTileCoordinates:_character.summonType withOriginCoordinate:CGPointZero]];
}

// Return coordinates of tiles given an area type and a character's current position
- (NSArray *)areaTileCoordinates:(GWAreaType)type withOriginCoordinate:(CGPoint)origin {
    
    NSMutableArray *tileCoordinates = [[NSMutableArray alloc] init];
    
    switch (type) {
        case kGWAreaType3x3Square:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col - 1)]];
            break;
        case kGWAreaTypeCross:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            break;
        case kGWAreaTypeLargeCross:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 2, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 2, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 2)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 2)]];
            break;
        case kGWAreaTypeSquareCross:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 2, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 2, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 2)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 2)]];
            break;
        case kGWAreaTypeLine1:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            break;
        case kGWAreaTypeLine2:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            break;
        case kGWAreaTypeLine3:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            break;
        case kGWAreaTypeDiagonal:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col + 1)]];
            break;
        case kGWAreaTypeLeftSquigly:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col - 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            break;
        case kGWAreaTypeRightSquigly:
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row + 1, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row, self.col + 1)]];
            [tileCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(self.row - 1, self.col + 1)]];
            break;
        default:
            break;
    }
    
    // Rotating coordinates
    for (int i=0; i<[tileCoordinates count]; i++) {
        NSValue *tileCoordinateValue = tileCoordinates[i];
        CGPoint tileCoordinate = tileCoordinateValue.CGPointValue;
        
        // Rotate accordingly
        tileCoordinate = [self rotate:tileCoordinate angle:_rotation * M_PI / 2];
        
        // Set new rotated value
        tileCoordinates[i] = [NSValue valueWithCGPoint:tileCoordinate];
    }
    
    return (NSArray *)tileCoordinates;
}

@end
