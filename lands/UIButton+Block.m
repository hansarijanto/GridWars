//
//  UIButton+Block.m
//  Athos
//
//  Created by Anders Borch on 10/3/14.
//  Copyright (c) 2014 Athos. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

- (void)addTarget:(id)target withBlock:(UIButtonBlock)block forControlEvents:(UIControlEvents)controlEvents
{
    NSInteger count = 1;
    while (controlEvents & UIControlEventAllTouchEvents) {
        if (controlEvents & 1) {
            NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)count);
            if (!blocks) {
                blocks = [[NSMutableDictionary alloc] init];
                objc_setAssociatedObject(self, (void *)count, blocks, OBJC_ASSOCIATION_RETAIN);
                SEL selector = NSSelectorFromString([NSString stringWithFormat: @"blockTarget%ld:event:", (long)count]);
                if ([self actionsForTarget: self forControlEvent: 1 << count].count == 0) {
                    [self addTarget: self
                             action: selector
                   forControlEvents: 1 << (count - 1)];
                }
            }
            blocks[@([target hash])] = [block copy];
        }
        controlEvents >>= 1;
        count++;
    }
}

- (void)removeBlockTarget:(id)target forControlEvents:(UIControlEvents)controlEvents
{
    NSInteger count = 1;
    while (controlEvents & UIControlEventAllTouchEvents) {
        if (controlEvents & 1) {
            NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)count);
            [blocks removeObjectForKey: @([target hash])];
            if (blocks && [blocks allKeys].count == 0) {
                objc_setAssociatedObject(self, (void *)count, nil, OBJC_ASSOCIATION_COPY);
            }
        }
        controlEvents >>= 1;
        count++;
    }
}

- (void)blockTarget1:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)1);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget2:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)2);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget3:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)3);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget4:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)4);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget5:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)5);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget6:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)6);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget7:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)7);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget8:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)8);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

- (void)blockTarget9:(id)sender event:(UIEvent*)event
{
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, (void *)9);
    for (UIButtonBlock block in [blocks allValues]) {
        block(sender, event);
    }
}

@end
