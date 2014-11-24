//
//  GWCharacter.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionarySerializable.h"

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

@interface GWCharacter : DictionarySerializable

- (instancetype)initWithType:(GWCharacterType)type;

- (void)decrementActions; // Call after a character moves (decrements move count)
- (void)resetMoves; // Resets number of moves to maxMoves
- (void)damagedBy:(GWCharacter *)attacker; // When attacked by another character
- (NSString *)characterClass;
+ (NSArray *)getAllPossibleCharacters;

@property(nonatomic, assign) GWCharacterType type;
@property(nonatomic, assign) GWAreaType moveType;
@property(nonatomic, assign) GWAreaType summonType;
@property(nonatomic, assign) GWAreaType territoryType;
@property(nonatomic, assign) GWAreaType attackType;
@property(nonatomic, assign) NSUInteger actions; // Number of moves left
@property(nonatomic, assign) NSUInteger maxActions; // Number of moves (for moving and attacking)
@property(nonatomic, assign) NSInteger health;
@property(nonatomic, assign) NSInteger maxHealth;
@property(nonatomic, assign) NSInteger attack;
@property(nonatomic, strong) NSString *characterClass;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) GWPlayer *owner;

@end
