//
//  GWHealthBar.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-17.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWHealthBar.h"
#import "UIView+Shapes.h"

@implementation GWHealthBar {
    UIView *_bar;
    UIColor *_barColor;
    UIColor *_barColorMediumHealth;
    UIColor *_barColorLowHealth;
    float _mediumThreshold;
    float _lowThreshold;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _lowThreshold = 0.2f;
        _mediumThreshold = 0.5f;
        
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 3.0f;
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.masksToBounds = YES;
        
        _barColor = [UIColor greenColor];
        _barColorMediumHealth = [UIColor yellowColor];
        _barColorLowHealth = [UIColor redColor];
        
        _bar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [_bar setBackgroundColor:_barColor];
        [self addSubview:_bar];
    }
    return self;
}

- (void)setCornerRadius:(float)radius {
    self.layer.cornerRadius = radius;
}

- (void)setBorderWidth:(float)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    if (_percentage > _mediumThreshold) [_bar setBackgroundColor:_barColor];
}

- (void)setBarColorMediumHealth:(UIColor *)barColor {
    _barColorMediumHealth = barColor;
    if (_percentage <= _mediumThreshold && _percentage > _lowThreshold) [_bar setBackgroundColor:_barColorMediumHealth];
}

- (void)setBarColorLowHealth:(UIColor *)barColor {
    _barColorLowHealth = barColor;
    if (_percentage < _lowThreshold) [_bar setBackgroundColor:_barColorLowHealth];
}

- (void)setPercentage:(float)percentage {
    _percentage = percentage;
    [UIView animateWithDuration:0.5 animations:^{
        
        if (_percentage > _mediumThreshold) {
            [_bar setBackgroundColor:_barColor];
        } else if (_percentage <= _mediumThreshold && _percentage > _lowThreshold) {
            [_bar setBackgroundColor:_barColorMediumHealth];
        } else {
            [_bar setBackgroundColor:_barColorLowHealth];
        }
        
        _bar.frame = CGRectMake(0.0f, 0.0f, _percentage * self.bounds.size.width, _bar.frame.size.height);
    }];
}

@end
