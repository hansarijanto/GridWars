//
//  GWAreaView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWAreaView.h"
#import "UIView+Shapes.h"

@implementation GWAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setBackgroundColor:[UIColor whiteColor]];
    return self;
}

- (void)setCoordinates:(NSArray *)coordinates {
    _coordinates = coordinates;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat tileWidth = self.frame.size.width / 3;
    CGFloat tileHeight = self.frame.size.height / 3;
    
    for (NSValue *value in _coordinates) {
        CGPoint coordinate = value.CGPointValue;
        CGRect tileRect = CGRectMake(coordinate.x * tileWidth, coordinate.y * tileHeight, tileWidth, tileHeight);
        [self drawRectangle:tileRect withFillColor:[UIColor redColor] withStrokeColor:[UIColor blackColor]];
    }
}


@end
