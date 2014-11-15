//
//  UIView+Shapes.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shapes)

- (void)drawCircle:(CGRect)rectangle withFillColor:(UIColor *)fillColor withStrokeColor:(UIColor *)strokeColor;
- (void)drawRectangle:(CGRect)rectangle withFillColor:(UIColor *)fillColor withStrokeColor:(UIColor *)strokeColor;

@end
