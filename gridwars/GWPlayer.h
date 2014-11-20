//
//  GWPlayer.h
//  gridwars
//
//  Created by Hans Arijanto on 11/19/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGWPlayerNone,
    kGWPlayer1,
    kGWPlayer2
} GWPlayerNumber;

@class GWCharacter;

@interface GWPlayer : NSObject

@property(nonatomic, readwrite) GWPlayerNumber playerNumber;
@property(nonatomic, readonly) GWCharacter *leader;
@property(nonatomic, readonly) NSArray *characters;

@end
