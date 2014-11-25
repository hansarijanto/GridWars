//
//  GCTurnBasedMatchHelper.m
//  lands
//
//  Created by Hans Arijanto on 11/24/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GCTurnBasedMatchHelper.h"
#import "GWAppDelegate.h"
#import "GWRootViewController.h"

@interface GCTurnBasedMatchHelper () <GKTurnBasedMatchmakerViewControllerDelegate> {
    
    BOOL _gameCenterFeaturesEnabled;
    
}
@end


@implementation GCTurnBasedMatchHelper

@synthesize delegate;
@synthesize currentMatch;
@synthesize gameCentreAvailable;

static GCTurnBasedMatchHelper *sharedControl = nil;
+ (GCTurnBasedMatchHelper *) sharedInstance {
    if (!sharedControl) {
        sharedControl = [[GCTurnBasedMatchHelper alloc]init];
    }
    return sharedControl;
}

-(BOOL)isGameCentreAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        
        gameCentreAvailable = [self isGameCentreAvailable];
        if (gameCentreAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
        
    }
    return self;
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication Changed. User Authenticated");
        userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        
        NSLog(@"Authentication Changed. User Not Authenticated");
        userAuthenticated = FALSE;
    }
    
}


-(void) authenticateLocalUser {
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *gcvc,NSError *error) {
            
            //TODO Remove:: Removes all active matches (for testing)
//            [self removeAllMatches];
            [[GKLocalPlayer localPlayer] registerListener:self];
            
            if(gcvc) {
                [self presentViewController:gcvc];
            }
            else {
                _gameCenterFeaturesEnabled = NO;
                [[GKLocalPlayer localPlayer] registerListener:nil];
            }
        };
    }
    
    else if ([GKLocalPlayer localPlayer].authenticated == YES){
        _gameCenterFeaturesEnabled = YES;
    }
    
}

- (void)removeAllMatches {
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:
     ^(NSArray *matches, NSError *error){
         for (GKTurnBasedMatch *match in matches) {
             NSLog(@"%@", match.matchID);
             [match removeWithCompletionHandler:^(NSError *error){
                 NSLog(@"%@", error);}];
         }}];
}

-(UIViewController*) getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)gcvc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:gcvc animated:YES completion:nil];
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
}

// Show GCTurnBasedMatchMaker UI and create match request
- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController {
    if (!gameCentreAvailable) return;
    
    presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]
     initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;
    
    [presentingViewController presentViewController:mmvc animated:YES completion:nil];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate

// When a match is found
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    [presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
    self.currentMatch = match;
    
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate == NULL) {
        // It's a new game!
        [delegate startNewMatch:match];
    } else {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // It's your turn!
            [delegate updateCurrentMatch:match];
            [delegate myTurnCurrentMatch:match];
        } else {
            // It's not your turn, just display the game state.
            [delegate updateCurrentMatch:match];
        }
    }
    
    NSLog(@"did find match, %@", match);
}

// Cancelling match finding
- (void)turnBasedMatchmakerViewControllerWasCancelled: (GKTurnBasedMatchmakerViewController *)viewController {
    [presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"has cancelled");
}

// Error match finding
- (void)turnBasedMatchmakerViewController: (GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currentIndex =
    [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:
                (currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        }
    }
    NSLog(@"playerquitforMatch, %@, %@",
          match, match.currentParticipant);
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit nextParticipants:@[part] turnTimeout:60.0f matchData:match.matchData completionHandler:nil];
}

#pragma mark GKLocalPlayerListener

// When another player completes a turn
- (void)player:(GKPlayer *)player receivedTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive {
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [delegate myTurnCurrentMatch:match];
        } else {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [delegate updateCurrentMatch:match];
        }
    } else {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's not the current match and it's our turn now
            [delegate receivedNotice:@"It's your turn for another match"
                        forOtherMatch:match];
        } else {
            // it's the not current match, and it's someone else's
            // turn
            [delegate receivedNotice:@"It's someone else's turn"
                        forOtherMatch:match];
        }
    }
}

// When a match ends
- (void)player:(GKPlayer *)player matchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        [delegate receivedEndCurrentMatch:match];
    } else {
        [delegate receivedNotice:@"Another Game Ended!" forOtherMatch:match];
    }
}


@end
