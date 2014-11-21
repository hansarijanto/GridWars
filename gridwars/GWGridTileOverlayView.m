//
//  GWGridTileOverlayView.m
//  gridwars
//
//  Created by Hans Arijanto on 11/20/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridTileOverlayView.h"
#import "GWGridTile.h"
#import "UIView+Shapes.h"
#import "GWGridPieceCharacter.h"

@implementation GWGridTileOverlayView {
    GWGridTile *_tile;
    UIView *_overlay;
}

- (id)initWithFrame:(CGRect)frame withTile:(GWGridTile *)tile
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _tile = tile;
    
    _overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _overlay.layer.borderWidth = 2.0f;
    _overlay.layer.cornerRadius = 4.0f;
    _overlay.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:_overlay];

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [_overlay setBackgroundColor:[UIColor clearColor]];
    
    if (!_tile.hidden) {

        switch (_tile.state) {
            case kGWTileStateSelectableAsMovingDestination:
                [_overlay setBackgroundColor:[UIColor colorWithRed:2.0f/255.0f green:127.0f/255.0f blue:60.0f/255.0f alpha:0.6f]];
                break;
                
            case kGWTileStateSelectableAsAttack:
                [_overlay setBackgroundColor:[UIColor colorWithRed:163.0f/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:0.6f]];
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
