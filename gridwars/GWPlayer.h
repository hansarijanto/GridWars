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
    kGWPlayerRed, // Player playing from the bottom of the grid (red)
    kGWPlayerBlue // Player playing from the top of the grid (blue)
} GWPlayerTeam;

@class GWCharacter;

@interface GWPlayer : NSObject

@property(nonatomic, readwrite) GWPlayerTeam team;
@property(nonatomic, readonly) GWCharacter *leader;
@property(nonatomic, readonly) NSArray *deck;
@property(nonatomic, readonly) NSArray *inventory;
@property(nonatomic, strong) UIColor *teamColor;

- (void)addCharacterToInventory:(GWCharacter *)character;
- (void)moveCharacterFromInventoryToDeck:(GWCharacter *)character;
- (void)moveCharacterFromDeckToInventory:(GWCharacter *)character;
- (void)makeLeader:(GWCharacter *)character;

@end
