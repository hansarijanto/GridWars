//
//  GWCharacter.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGWAreaTypePoint,
    kGWAreaTypeLine1,
    kGWAreaTypeLine2,
    kGWAreaTypeLine3,
    kGWAreaTypeDiagonal,
    kGWAreaTypeCross,
    kGWAreaTypeLargeCross,
    kGWAreaType3x3Square,
    kGWAreaTypeSquareCross,
    kGWAreaTypeLeftSquigly,
    kGWAreaTypeRightSquigly,
    kGWAreaTypeT,
} GWAreaType;

typedef enum {
    kGWCharacterTypeWarrior,
    kGWCharacterTypeArcher,
    kGWCharacterTypePriest,
    kGWCharacterTypeMage,
    kGWCharacterTypeThief,
} GWCharacterType;

@class GWPlayer;

@interface GWCharacter : NSObject

- (instancetype)initWithType:(GWCharacterType)type;

- (void)decrementActions; // Call after a character moves (decrements move count)
- (void)resetMoves; // Resets number of moves to maxMoves
- (void)damagedBy:(GWCharacter *)attacker; // When attacked by another character
- (NSString *)characterClass;
+ (NSArray *)getAllPossibleCharacters;

@property(nonatomic, readonly) GWCharacterType type;
@property(nonatomic, readonly) GWAreaType moveType;
@property(nonatomic, readonly) GWAreaType summonType;
@property(nonatomic, readonly) GWAreaType territoryType;
@property(nonatomic, readonly) GWAreaType attackType;
@property(nonatomic, readonly) NSUInteger actions; // Number of moves left
@property(nonatomic, readonly) NSUInteger maxActions; // Number of moves (for moving and attacking)
@property(nonatomic, readonly) NSInteger health;
@property(nonatomic, readonly) NSInteger maxHealth;
@property(nonatomic, readonly) NSInteger attack;
@property(nonatomic, strong, readonly) NSString *characterClass;
@property(nonatomic, strong, readonly) NSString *image;
@property(nonatomic, strong, readonly) NSUUID *uuid;
@property(nonatomic, strong) GWPlayer *owner;

@end
