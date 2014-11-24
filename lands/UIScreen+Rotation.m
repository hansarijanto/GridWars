//
//  UIScreen+Rotation.m
//  Athos
//
//  Created by Anders Borch on 7/22/14.
//  Copyright (c) 2014 Anders Borch. All rights reserved.
//

#import "UIScreen+Rotation.h"

@implementation UIScreen (Rotation)

/*
 Get screen bounds and flip width and height if
 current device orientation is landscape.
 */
- (CGRect)orientationRelativeBounds
{
    CGRect bounds = UIScreen.mainScreen.bounds;
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        bounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
    }
    return bounds;
}

@end
