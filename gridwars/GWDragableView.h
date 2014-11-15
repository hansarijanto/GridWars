//
//  UIDragableView.h
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GWDragableViewBlock)(CGPoint point);

@interface GWDragableView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)resetPosition;
- (void)setOnTouchBlock:(GWDragableViewBlock)block;
- (void)setOnPanBlock:(GWDragableViewBlock)block;
- (void)setOnEndBlock:(GWDragableViewBlock)block;
- (void)setOnTapBlock:(dispatch_block_t)block;

@end
