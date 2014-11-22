//
//  GWBannerViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 11/21/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWBannerViewController.h"
@interface GWBannerViewController ()

@end

@implementation GWBannerViewController {
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (!self) return nil;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    
    return self;
}

- (void)setTitleWithAnimation:(NSString *)title withColor:(UIColor *)titleColor {
    [UIView animateWithDuration:0.5f animations:^{
        _titleLabel.frame = CGRectOffset(_titleLabel.frame, 50.0f, 0.0f);
        _titleLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _titleLabel.frame = CGRectOffset(_titleLabel.frame, -100.0f, 0.0f);
        
        _titleLabel.text = title;
        if (titleColor) _titleLabel.textColor = titleColor;
        else _titleLabel.textColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.5f animations:^{
            _titleLabel.frame = CGRectOffset(_titleLabel.frame, 50.0f, 0.0f);
            _titleLabel.alpha = 1.0f;
        }];
    }];
}

@end
