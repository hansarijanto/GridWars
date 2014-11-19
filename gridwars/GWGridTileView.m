//
//  GWGridTileView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-13.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridTileView.h"
#import "GWGridTile.h"

@implementation GWGridTileView {
    UIImageView *_image;
    UIView *_overlay;
}

- (id)initWithFrame:(CGRect)frame withTile:(GWGridTile *)tile
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _tile = tile;
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [self addSubview:_image];
    
    _overlay = [[UIView alloc] initWithFrame:_image.frame];
    _overlay.layer.borderWidth = 2.0f;
    _overlay.layer.cornerRadius = 4.0f;
    _overlay.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:_overlay];
                
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!_tile.hidden) {
        
        UIColor *fillColor = [UIColor colorWithRed:200.0f/255.0f green:10.0f/255.0f blue:40.0f/255.0f alpha:0.85f];
        
        // Set tile image
        switch (_tile.state) {
            case kGWTileStateSelectableAsMovingDestination:
                _overlay.layer.borderColor = [UIColor colorWithRed:2.0f/255.0f green:127.0f/255.0f blue:60.0f/255.0f alpha:1.0f].CGColor;
                break;
            
            case kGWTileStateSelectableAsAttack:
                _overlay.layer.borderColor = [UIColor colorWithRed:163.0f/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:1.0f].CGColor;
                break;
                
            case kGWTileStateSelectableForCancel:
                break;
                
            case kGWTileStateSummoning:
                break;
                
            case kGWTileStateIdle:
                _overlay.layer.borderColor = [UIColor clearColor].CGColor;
                if (_tile.walkable) {
                } else {
                    fillColor = [UIColor clearColor];
                }
                break;
                
            default:
                break;
        }
        
        [self drawRectangle:rect withFillColor:fillColor withStrokeColor:[UIColor blackColor]];
    }
}

@end
