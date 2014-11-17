//
//  GWGridTileView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-13.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridTileView.h"
#import "GWGridTile.h"

@implementation GWGridTileView

- (id)initWithFrame:(CGRect)frame withTile:(GWGridTile *)tile
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _tile = tile;
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if (!_tile.hidden) {
        UIColor *fillColor;
        
        // Set fill color based on state
        switch (_tile.state) {
            case kGWTileStateSelectableAsMovingDestination:
                fillColor = [UIColor greenColor];
                break;
                
            case kGWTileStateSelectableForCancel:
                fillColor = [UIColor blueColor];
                break;
                
            case kGWTileStateSummoning:
                fillColor = [UIColor redColor];
                break;
                
            case kGWTileStateIdle:
                if (_tile.walkable) fillColor = [UIColor grayColor];
                else fillColor = [UIColor whiteColor];
                break;
                
            default:
                fillColor = [UIColor purpleColor];
                break;
        }
        
        // Draw tile
        [self drawRectangle:rect withFillColor:fillColor withStrokeColor:[UIColor blackColor]];
    }
}


@end
