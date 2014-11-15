//
//  UIDragableView.m
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWDragableView.h"

@implementation GWDragableView {
    CGPoint _originalPosition;
    GWDragableViewBlock _onPanBlock; // When object is beign dragged
    GWDragableViewBlock _onTouchBlock; // When object is first selected
    GWDragableViewBlock _onEndBlock; // When object is draged and is let go
    dispatch_block_t _onTapBlock; // When object is draged and is tapped
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    self.gestureRecognizers = @[panRecognizer];
    
    return self;
}

- (void)setOnPanBlock:(GWDragableViewBlock)block {
    _onPanBlock = block;
}

- (void)setOnTouchBlock:(GWDragableViewBlock)block {
    _onTouchBlock = block;
}

- (void)setOnEndBlock:(GWDragableViewBlock)block {
    _onEndBlock = block;
}

- (void)setOnTapBlock:(dispatch_block_t)block {
    _onTapBlock = block;
}

- (void) detectPan:(UIPanGestureRecognizer *) uiPanGestureRecognizer
{
    CGPoint translation = [uiPanGestureRecognizer translationInView:self.superview];
    switch (uiPanGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // Promote the touched view
            [self.superview bringSubviewToFront:self];
            
            // Remember original location
            _originalPosition = self.center;
            if (_onTouchBlock) _onTouchBlock(self.center);
            break;
        case UIGestureRecognizerStateEnded:
            if (_onEndBlock) _onEndBlock(self.center);
            break;
            
        default:
            self.center = CGPointMake(_originalPosition.x + translation.x,
                                      _originalPosition.y + translation.y);
            if (_onPanBlock) _onPanBlock(self.center);
            break;
    }
}

- (void) resetPosition {
    self.center = _originalPosition;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_onTapBlock) _onTapBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
