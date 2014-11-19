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
                _image.image = [UIImage imageNamed:@"blackGem"];
                break;
                
            case kGWTileStateIdle:
                _overlay.layer.borderColor = [UIColor clearColor].CGColor;
                if (_tile.walkable) {
                    _image.image = [UIImage imageNamed:@"blackGem"];
                } else {
                    _image.image = nil;
                }
                break;
                
            default:
                break;
        }
        
        [self drawRectangle:rect withFillColor:[UIColor whiteColor] withStrokeColor:[UIColor blackColor]];
    }
}

@end
