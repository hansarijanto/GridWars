//
//  UIButton+Block.h
//  Athos
//
//  Created by Anders Borch on 10/3/14.
//  Copyright (c) 2014 Athos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIButtonBlock)(id sender, UIEvent *event);

@interface UIButton (Block)

- (void)addTarget:(id)target withBlock:(UIButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;
- (void)removeBlockTarget:(id)target forControlEvents:(UIControlEvents)controlEvents;

@end
