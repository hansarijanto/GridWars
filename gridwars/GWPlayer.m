//
//  GWPlayer.m
//  gridwars
//
//  Created by Hans Arijanto on 11/19/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWPlayer.h"
#import "GWCharacter.h"

@implementation GWPlayer

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _deck = [[NSArray alloc] init];
    _inventory = [[NSArray alloc] init];
    
    return self;
}

#pragma mark - setter/getter

- (UIColor *)teamColor {
    switch (_team) {
        case kGWPlayerRed:
            return [UIColor colorWithRed:255.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:0.8f];
            break;
        case kGWPlayerBlue:
            return [UIColor colorWithRed:40.0f/255.0f green:80.0f/255.0f blue:200.0f/255.0f alpha:0.8f];
            break;
        default:
            break;
    }
    
    return [UIColor clearColor];
}

- (BOOL)makeLeader:(GWCharacter *)character {
    for (GWCharacter *deckCharacter in _deck) {
        if (deckCharacter == character) {
            _leader = character;
            [self save];
            return YES;
        }
    }
    return NO;
}

- (NSNumber *)leaderIndex {
    for (int i=0; i<[_deck count]; i++) {
        GWCharacter *deckCharacter = _deck[i];
        if (deckCharacter == _leader) {
            return [NSNumber numberWithInt:i];
        }
    }
    
    return nil;
}

#pragma mark - moving characters from deck to from characters

- (void)addCharacterToInventory:(GWCharacter *)character {
    character.owner = self;
    NSMutableArray *characters = [_inventory mutableCopy];
    [characters addObject:character];
    _inventory = (NSArray *)characters;
    [self save];
}

- (void)removeCharacterFromInventory:(GWCharacter *)character {
    NSMutableArray *characters = [_inventory mutableCopy];
    [characters removeObject:character];
    _inventory = (NSArray *)characters;
    [self save];
}

- (void)addCharacterToDeck:(GWCharacter *)character {
    NSMutableArray *deck = [_deck mutableCopy];
    [deck addObject:character];
    _deck = (NSArray *)deck;
    [self save];
}

- (void)removeCharacterFromDeck:(GWCharacter *)character {
    NSMutableArray *deck = [_deck mutableCopy];
    [deck removeObject:character];
    _deck = (NSArray *)deck;
    [self save];
}

- (void)moveCharacterFromInventoryToDeck:(GWCharacter *)character {
    for (GWCharacter *ownedCharacter in _inventory) {
        if (ownedCharacter == character) {
            [self removeCharacterFromInventory:character];
            [self addCharacterToDeck:character];
            return;
        }
    }
}

- (void)moveCharacterFromDeckToInventory:(GWCharacter *)character {
    for (GWCharacter *deckCharacter in _deck) {
        if (deckCharacter == character) {
            [self removeCharacterFromDeck:character];
            [self addCharacterToInventory:character];
            return;
        }
    }
}

- (void)setDeck:(NSArray *)deck {
    _deck = deck;
}

#pragma mark - dictionary serializable

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    NSMutableDictionary *dict = [dictionary mutableCopy];

    dictionary = dict;
    if ((self = [super initWithDictionary: dictionary])) {
        NSMutableArray *inventory = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in _inventory) {
            GWCharacter *character = [[GWCharacter alloc] initWithDictionary: dict];
            character.owner = self;
            [inventory addObject: character];
        }
        _inventory = inventory;
        
        NSMutableArray *deck = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in _deck) {
            GWCharacter *character = [[GWCharacter alloc] initWithDictionary: dict];
            character.owner = self;
            [deck addObject: character];
        }
        _deck = deck;
        
        NSNumber *leaderIndex = dict[@"leaderIndex"];
        if (leaderIndex) {
            _leader = _deck[[leaderIndex integerValue]];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dict = (NSMutableDictionary*)[super dictionaryValue];
    
    NSMutableArray *inventory = [NSMutableArray array];
    for (GWCharacter *character in _inventory) {
        [inventory addObject: [character dictionaryValue]];
    }
    dict[@"inventory"] = inventory;
    
    NSMutableArray *deck = [NSMutableArray array];
    for (GWCharacter *character in _deck) {
        [deck addObject: [character dictionaryValue]];
    }
    dict[@"deck"] = deck;
    [dict removeObjectForKey:@"leader"];
    if (self.leaderIndex) dict[@"leaderIndex"] = self.leaderIndex;
    return dict;
}

+ (GWPlayer *)load {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDict = [ud objectForKey: @"User"];
    GWPlayer *currentUser = [[GWPlayer alloc] initWithDictionary: userDict];
    return currentUser;
}

- (void)save {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject: [self dictionaryValue]
           forKey: @"User"];
    [ud synchronize];
}

@end
