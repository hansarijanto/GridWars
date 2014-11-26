//
//  ViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWPlayer;

@interface GWRootViewController : UIViewController

@property(nonatomic, strong)GWPlayer *currentPlayer;
@property(nonatomic, strong, readonly)UIViewController *mainController;

- (void)startGame; // start a game
- (void)changeMainController:(UIViewController *)controller;
- (void)showCharacterManager;
- (void)showMatchMaker; // presents match maker view controller view

@end
