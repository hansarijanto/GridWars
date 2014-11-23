//
//  ViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWRootViewController.h"
#import "GWCharacterStoreViewController.h"
#import "GWGameViewController.h"
#import "GWGrid.h"
#import "GWPlayer.h"

@interface GWRootViewController ()

@end

@implementation GWRootViewController {
    UIViewController *_mainController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Hiding status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    // Create grid
    GWGrid *grid = [[GWGrid alloc] init];
    grid.tileSize = CGSizeMake(37.5f, 37.5f);
    [grid gridWithNumHorTiles:8 withNumVertTile:9];
    
    // Create main player
    GWPlayer *player = [[GWPlayer alloc] init];
    player.team = kGWPlayerRed;
    
    // Create enemy
    GWPlayer *enemy = [[GWPlayer alloc] init];
    enemy.team = kGWPlayerBlue;
    
    // Create game view controller
//    GWGameViewController *game = [[GWGameViewController alloc] initWithPlayer:player withEnemy:enemy withGrid:grid];
//    [self addChildViewController:game];
//    [self.view addSubview:game.view];
    
    GWCharacterStoreViewController *store = [[GWCharacterStoreViewController alloc] initWithPlayer:player];
    [self changeMainController:store];
    
}

- (void)changeMainController:(UIViewController *)controller {
    if (_mainController) {
        [_mainController removeFromParentViewController];
        [_mainController.view removeFromSuperview];
        _mainController = nil;
    }
    
    _mainController = controller;
    [self addChildViewController:_mainController];
    [self.view addSubview:_mainController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
