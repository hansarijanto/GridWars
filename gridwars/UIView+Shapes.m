//
//  UIView+Shapes.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "UIView+Shapes.h"

@implementation UIView (Shapes)

- (void)drawCircle:(CGRect)rectangle withFillColor:(UIColor *)fillColor withStrokeColor:(UIColor *)strokeColor {
    // Draw rectangle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef path = CGPathCreateWithEllipseInRect(rectangle, NULL);
    [fillColor setFill];
    [strokeColor setStroke];
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}

- (void)drawRectangle:(CGRect)rectangle withFillColor:(UIColor *)fillColor withStrokeColor:(UIColor *)strokeColor {
    // Draw rectangle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef path = CGPathCreateWithRect(rectangle, NULL);
    [fillColor setFill];
    [strokeColor setStroke];
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}

@end
