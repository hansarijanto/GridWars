//
//  GWAreaView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWAreaView.h"
#import "GWGridCoordinate.h"
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
    
    for (GWGridCoordinate *coordinate in _coordinates) {
        CGRect tileRect = CGRectMake((coordinate.col + 1) * tileWidth, (coordinate.row + 1) * tileHeight, tileWidth, tileHeight);
        [self drawRectangle:tileRect withFillColor:[UIColor redColor] withStrokeColor:[UIColor blackColor]];
    }
}


@end
