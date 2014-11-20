//
//  GWGameViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGridTile;
@class GWPlayer;
@class GWGrid;

@interface GWGameViewController : UIViewController

@property(nonatomic, strong, readonly)GWPlayer *activePlayer;

- (instancetype)initWithPlayer:(GWPlayer *)player withEnemy:(GWPlayer *)enemy withGrid:(GWGrid *)grid;

@end
