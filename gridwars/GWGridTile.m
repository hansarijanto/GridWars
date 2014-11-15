//
//  GWGridTile.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridTile.h"
#import "GWGridPiece.h"
#import "GWGridPieceCharacter.h"
#import "GWGridCoordinate.h"

@implementation GWGridTile

- (instancetype)initWithSize:(CGSize)size withCoordinates:(GWGridCoordinate *)coordinates {
    self = [super init];
    if (!self) return nil;
    
    _hidden = NO;
    _walkable = NO;
    _size = size;
    _state = kGWTileStateIdle;
    [self moveTo:coordinates];
    
    return self;
}

- (BOOL)hasCharacter {
    if (!_piece) return NO;
    return [_piece isCharacter];
}


#pragma mark - GWGridCell

- (void)drawRect:(CGRect)rect forView:(UIView *)view {
    // Don't draw tile if it is hidden
    if (!_hidden) {
        UIColor *fillColor;
        
        // Set fill color based on state
        switch (_state) {
            case kGWTileStateSelectableAsMovingDestination:
                fillColor = [UIColor greenColor];
                break;
                
            case kGWTileStateSelectableForCancel:
                fillColor = [UIColor blueColor];
                break;
                
            default:
                fillColor = [UIColor lightGrayColor];
                break;
        }
        
        // Draw tile
        [view drawRectangle:rect withFillColor:fillColor withStrokeColor:[UIColor blackColor]];
    }
}

@end
