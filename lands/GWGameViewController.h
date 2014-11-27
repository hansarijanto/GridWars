//
//  GWGameViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiplayerNetworking.h"

@class GWGridTile;
@class GWPlayer;
@class GWGrid;

@interface GWGameViewController : UIViewController <MultiplayerNetworkingProtocol>

@property(nonatomic, strong, readonly)GWPlayer *activePlayer;
@property(nonatomic, strong, readonly)MultiplayerNetworking *multiplayerManager;

- (instancetype)initWithPlayer:(GWPlayer *)player withEnemy:(GWPlayer *)enemy withGrid:(GWGrid *)grid;

@end
