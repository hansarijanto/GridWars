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

@interface GWRootViewController ()

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
    
    // Set GCTurnMatchDelegate
    [GCTurnBasedMatchHelper sharedInstance].delegate = self;
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

- (void)showMatchFinder {
    if (!_currentPlayer.leader) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"You must have a leader to start a game"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[GCTurnBasedMatchHelper sharedInstance]
     findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - GCTurnBasedMatchHelperDelegate

// Newly created match
- (void)startNewMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game....");
    
    // Send player info to the other player, this will intiate the invite
    GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    NSString *dataString = @"DATA";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding ];
    
    // Choosing the next participant
    NSUInteger currentIndex = [currentMatch.participants
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) % [currentMatch.participants count];
    nextParticipant = [currentMatch.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [currentMatch.participants count]; i++) {
        nextParticipant = [currentMatch.participants objectAtIndex:((currentIndex + 1 + i) % [currentMatch.participants count ])];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        }
    }
    
    [currentMatch endTurnWithNextParticipants:@[nextParticipant] turnTimeout:60.0f matchData:data completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    NSLog(@"Send invite, %@, %@", data, nextParticipant);
}

// When you select game thats "your turn" form the list of games
// When a player from ther current match ends their turn and it is now your turn
- (void)myTurnCurrentMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Taking turn in existing game");
    [self startGame];    
    if ([match.matchData bytes]) {
    }
}

// When a player in the current match ends their turn
- (void)updateCurrentMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    }
    
    NSString *stringData = [NSString stringWithUTF8String:
                            [match.matchData bytes]];
    NSLog(@"Send data when its not my turn %@", stringData);
}

// Notice send from other non current matches
- (void)receivedNotice:(NSString *)notice forOtherMatch:(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:
                       @"Another game needs your attention!" message:notice
                                                delegate:self cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
}

// When the current match ends
- (void)receivedEndCurrentMatch:(GKTurnBasedMatch *)match {
    NSLog(@"endGame");
}

@end
