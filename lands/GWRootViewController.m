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
#import "UIScreen+Rotation.h"
#import "GameKitHelper.h"

@interface GWRootViewController ()<GameKitHelperDelegate>

@end

@implementation GWRootViewController {
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Add observer to detect when a player is authenticated
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated)
                                                 name:LocalPlayerIsAuthenticated object:nil];
    
    // Add observer to handle showing authentication view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController)
                                                 name:PresentAuthenticationViewController
                                               object:nil];
    
    // Authenticate for GC
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)startGame {
    // Create grid
    GWGrid *grid = [[GWGrid alloc] init];
    
    if (UIScreen.mainScreen.orientationRelativeBounds.size.height <= 480.0f) {
        grid.tileSize = CGSizeMake(27.5f, 27.5f);
    } else {
        grid.tileSize = CGSizeMake(37.5f, 37.5f);
    }

    [grid gridWithNumHorTiles:8 withNumVertTile:9];
    
    _currentPlayer.team = kGWPlayerRed;
    
    // Create enemy
    GWPlayer *enemy = [GWPlayer dummy];
    enemy.team = kGWPlayerBlue;
    
    // Create game view controller
    GWGameViewController *game = [[GWGameViewController alloc] initWithPlayer:_currentPlayer withEnemy:enemy withGrid:grid];
    [self changeMainController:game];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - GameCenterNotificationCallbacks

// Called when local player needs to be authenticated by GC
- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    [self presentViewController:gameKitHelper.authenticationViewController
                       animated:YES
                     completion:nil];
}

- (void)showMatchMaker {
    // Don't start game if no leader
    if (!_currentPlayer.leader) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"You must have a leader to start a game"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    // Don't start game if not authenticated by GC
    } else if (![GameKitHelper isAuthenticated]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Please log into Game Center"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
}

// Called when local player is authenticated by GC
- (void)playerAuthenticated {
    NSLog(@"Local player Authenticated for GC");
}

#pragma mark GameKitHelperDelegate

- (void)matchStarted {
    NSLog(@"Match started");
}

- (void)matchEnded {
    NSLog(@"Match ended");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Received data");
}

@end
