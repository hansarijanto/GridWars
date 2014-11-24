//
//  GCTurnBasedMatchHelper.h
//  lands
//
//  Created by Hans Arijanto on 11/24/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCTurnBasedMatchHelper : NSObject {
    
    BOOL gameCentreAvailable;
    BOOL userAuthenticated;
    
}

@property (assign, readonly) BOOL gameCentreAvailable;

+ (GCTurnBasedMatchHelper *)sharedInstance;

-(void)authenticateLocalUser;


@end