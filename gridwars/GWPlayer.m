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

- (void)makeLeader:(GWCharacter *)character {
    for (GWCharacter *deckCharacter in _deck) {
        if (deckCharacter == character) {
            _leader = character;
            return;
        }
    }
}

#pragma mark - moving characters from deck to from characters

- (void)addCharacterToInventory:(GWCharacter *)character {
    character.owner = self;
    NSMutableArray *characters = [_inventory mutableCopy];
    [characters addObject:character];
    _inventory = (NSArray *)characters;
}

- (void)removeCharacterFromInventory:(GWCharacter *)character {
    NSMutableArray *characters = [_inventory mutableCopy];
    [characters removeObject:character];
    _inventory = (NSArray *)characters;
}

- (void)addCharacterToDeck:(GWCharacter *)character {
    NSMutableArray *deck = [_deck mutableCopy];
    [deck addObject:character];
    _deck = (NSArray *)deck;
}

- (void)removeCharacterFromDeck:(GWCharacter *)character {
    NSMutableArray *deck = [_deck mutableCopy];
    [deck removeObject:character];
    _deck = (NSArray *)deck;
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

@end
