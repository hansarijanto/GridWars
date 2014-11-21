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
    UIImageView *_overlayImage;
}

- (id)initWithFrame:(CGRect)frame withTile:(GWGridTile *)tile
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.clipsToBounds = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    
    _tile = tile;
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [self addSubview:_image];
    
    if ((_tile.row + _tile.col) % 2 == 0) {
        _image.image = [UIImage imageNamed:@"grass1"];
    } else {
        _image.image = [UIImage imageNamed:@"grass2"];
    }
    
    _overlayImage = [[UIImageView alloc] initWithFrame:_image.frame];
    [self addSubview:_overlayImage];
                
    return self;
}

#pragma mark - animations

- (void)claimTerritoryAnimation {
    
    _overlayImage.alpha = 0.0f;
    _overlayImage.frame = CGRectOffset(_overlayImage.frame, 0.0f, -20.0f);
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _overlayImage.alpha = 1.0f;
                         _overlayImage.frame = CGRectOffset(_overlayImage.frame, 0.0f, 20.0f);
                     }
                     completion:nil];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!_tile.hidden) {
        
        if (_tile.territory == kGWPlayer1) {
            _overlayImage.image = [UIImage imageNamed:@"redGem"];
        } else if (_tile.territory == kGWPlayer2) {
            _overlayImage.image = [UIImage imageNamed:@"blueGem"];
        }
        
        // Set tile image
        switch (_tile.state) {
            case kGWTileStateSelectableAsMovingDestination:
                break;
            
            case kGWTileStateSelectableAsAttack:
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
