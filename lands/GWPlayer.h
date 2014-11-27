//
//  GWPlayer.h
//  gridwars
//
//  Created by Hans Arijanto on 11/19/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionarySerializable.h"
#import "GWCharacter.h"

typedef enum {
    kGWPlayerNone,
    kGWPlayerRed, // Player playing from the bottom of the grid (red)
    kGWPlayerBlue // Player playing from the top of the grid (blue)
} GWPlayerTeam;

@interface GWPlayer : DictionarySerializable

@property(nonatomic, readwrite) GWPlayerTeam team;
@property(nonatomic, strong) GWCharacter *leader;
@property(nonatomic, strong) NSArray *deck;
@property(nonatomic, strong) NSArray *inventory;

- (void)addCharacterToInventory:(GWCharacter *)character;
- (void)moveCharacterFromInventoryToDeck:(GWCharacter *)character;
- (void)moveCharacterFromDeckToInventory:(GWCharacter *)character;
- (BOOL)makeLeader:(GWCharacter *)character;
- (UIColor *)teamColor;
+ (GWPlayer *)dummy;

+ (GWPlayer *)load;
- (void)save;

@end
