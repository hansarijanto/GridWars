//
//  GWGridTileView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-13.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridTileView.h"
#import "GWGridTile.h"
#import "GWPlayer.h"

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
    
    if ((_tile.row + _tile.col) % 2 == 0) {
        _image.image = [UIImage imageNamed:@"grass1"];
    } else {
        _image.image = [UIImage imageNamed:@"grass2"];
    }
    
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
        
        _overlay.layer.borderColor = [UIColor clearColor].CGColor;
        [_overlay setBackgroundColor:[UIColor clearColor]];
        
        if (_tile.territory == kGWPlayer1) {
            _image.image = [UIImage imageNamed:@"tile"];
        }
        
        // Set tile image
        switch (_tile.state) {
            case kGWTileStateSelectableAsMovingDestination:
                [_overlay setBackgroundColor:[UIColor colorWithRed:2.0f/255.0f green:127.0f/255.0f blue:60.0f/255.0f alpha:0.4f]];
                break;
            
            case kGWTileStateSelectableAsAttack:
                [_overlay setBackgroundColor:[UIColor colorWithRed:163.0f/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:0.4f]];
                break;
                
            case kGWTileStateSelectableForCancel:
                break;
                
            case kGWTileStateSummoning:
                break;
                
            case kGWTileStateIdle:
                break;
                
            default:
                break;
        }
    }
}

@end
