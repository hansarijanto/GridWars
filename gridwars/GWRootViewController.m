//
//  ViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWRootViewController.h"
#import "GWCharacterManagerViewController.h"
#import "GWGameViewController.h"
#import "GWGrid.h"
#import "GWPlayer.h"

@interface GWRootViewController ()

@end

@implementation GWRootViewController {
    UIViewController *_mainController;
    GWCharacterManagerViewController *_characterManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Hiding status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    // Create main player
    GWPlayer *player = [GWPlayer load];
    if (!player) player = [[GWPlayer alloc] init];
    _currentPlayer = player;
    
    _characterManager = [[GWCharacterManagerViewController alloc] initWithPlayer:_currentPlayer];
    [self changeMainController:_characterManager];
    
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
    
    _mainController.view.alpha = 0.0f;
    _mainController.view.frame = CGRectOffset(_mainController.view.frame, 0.0f, 500.0f);
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _mainController.view.alpha = 1.0f;
                         _mainController.view.frame = CGRectOffset(_mainController.view.frame, 0.0f, -500.0f);
                     }];
}

- (void)showCharacterManager {
    [self changeMainController:_characterManager];
}

- (void)play {
    
    if (!_currentPlayer.leader) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"You must have a leader to start a game"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Create grid
    GWGrid *grid = [[GWGrid alloc] init];
    grid.tileSize = CGSizeMake(37.5f, 37.5f);
    [grid gridWithNumHorTiles:8 withNumVertTile:9];
    
    _currentPlayer.team = kGWPlayerRed;
    
    // Create enemy
    GWPlayer *enemy = [GWPlayer dummy];
    enemy.team = kGWPlayerBlue;
    
    // Create game view controller
    GWGameViewController *game = [[GWGameViewController alloc] initWithPlayer:_currentPlayer withEnemy:enemy withGrid:grid];
    [self changeMainController:game];
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
