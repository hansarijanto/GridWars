//
//  GCTurnBasedMatchHelper.h
//  lands
//
//  Created by Hans Arijanto on 11/24/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCTurnBasedMatchHelperDelegate
- (void)startNewMatch:(GKTurnBasedMatch *)match; // First turn
- (void)receivedEndCurrentMatch:(GKTurnBasedMatch *)match; // When a current match ends
- (void)updateCurrentMatch:(GKTurnBasedMatch *)match; // When a turn ends in a current match
- (void)myTurnCurrentMatch:(GKTurnBasedMatch *)match; // Start of player's turn in an current match
- (void)receivedNotice:(NSString *)notice forOtherMatch:(GKTurnBasedMatch *)match; // Notice from non current matches
@end

@interface GCTurnBasedMatchHelper : NSObject <GKLocalPlayerListener, GKTurnBasedMatchmakerViewControllerDelegate> {
    
    BOOL gameCentreAvailable;
    BOOL userAuthenticated;
    UIViewController *presentingViewController;
    
}

@property (nonatomic, retain)id <GCTurnBasedMatchHelperDelegate> delegate;
@property (assign, readonly) BOOL gameCentreAvailable;
@property (retain) GKTurnBasedMatch * currentMatch;

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController;

+ (GCTurnBasedMatchHelper *)sharedInstance;
- (void)authenticationChanged;
- (void)authenticateLocalUser;

// Ending a turn
/*
 GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
 
 [currentMatch endTurnWithNextParticipants:@[nextParticipant] turnTimeout:60.0f matchData:data completionHandler:^(NSError *error) {
 if (error) {
 NSLog(@"%@", error);
 }
 }];
 */

//Ending a match
/*
 GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
 [currentMatch endMatchInTurnWithMatchData:nil
 completionHandler:^(NSError *error) {
 if (error) {
 NSLog(@"%@", error);
 }
 }];
 */

@end