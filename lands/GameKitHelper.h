//
//  GameKitHelper.h
//  lands
//
//  Created by Hans Arijanto on 11/25/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

// A constant global object (like #define but for objects)
// Name of NSNotification sent when an authenticationViewController needs to be displayed
extern NSString *const PresentAuthenticationViewController;
// Name of NSNotification sent when an local player is authenticated for GC
extern NSString *const LocalPlayerIsAuthenticated;

@protocol GameKitHelperDelegate
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID;
@end

// GKMatchmakerViewControllerDelegate sends events regarding wether or not a match is found
// GKMatchDelegate sends events regarding sending/recieving data, connection status changes
@interface GameKitHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (nonatomic, strong) NSMutableDictionary *playersDict;
@property (nonatomic, readonly) UIViewController *authenticationViewController; // The built in GC authentication view controller (for login)
@property (nonatomic, readonly) NSError *lastError; // Last GC error
@property (nonatomic, strong) GKMatch *match; // Current GC match
@property (nonatomic, assign) id <GameKitHelperDelegate> delegate;

// Create match maker view controller and presents it
- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GameKitHelperDelegate>)delegate;

+ (instancetype)sharedGameKitHelper;
+ (BOOL)isAuthenticated;
- (void)authenticateLocalPlayer;
- (void)dismissMatchMaker;

@end