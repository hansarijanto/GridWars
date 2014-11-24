//
//  GWBannerViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 11/21/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWBannerViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setTitleWithAnimation:(NSString *)title withColor:(UIColor *)titleColor;

@end
