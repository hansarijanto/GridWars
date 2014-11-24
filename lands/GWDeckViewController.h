//
//  GWDeckViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWDeckViewController : UIViewController

@property(nonatomic, strong)NSArray *cellViews;
- (instancetype)initWithCellViews:(NSArray *)cellViews;
- (CGPoint)convertToOnScreenLocation:(CGPoint)location;

@end
