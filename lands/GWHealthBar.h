//
//  GWHealthBar.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-17.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWHealthBar : UIView

@property(nonatomic)float percentage;

- (void)setCornerRadius:(float)radius;
- (void)setBorderWidth:(float)borderWidth;
- (void)setBorderColor:(UIColor *)borderColor;

- (void)setBarColor:(UIColor *)barColor;
- (void)setBarColorLowHealth:(UIColor *)barColor;
- (void)setBarColorMediumHealth:(UIColor *)barColor;

- (void)setPercentage:(float)percentage;

@end
