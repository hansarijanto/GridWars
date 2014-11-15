//
//  GWCharacter.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCharacter.h"

@implementation GWCharacter

- (instancetype)initWithType:(GWCharacterType)type {
    self = [super init];
    if (!self) return nil;
    
    _uuid = [NSUUID UUID];
    _type = type;
    
    switch (_type) {
        case kGWCharacterTypeWarrior:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeLine2;
            _maxMoves   = 1;
            _moves      = 1;
            _health     = 150;
            _mana       = 50;
            break;
        case kGWCharacterTypeArcher:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeRightSquigly;
            _maxMoves   = 1;
            _moves      = 1;
            _health     = 50;
            _mana       = 70;
            break;
        case kGWCharacterTypeMage:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeDiagonal;
            _maxMoves   = 1;
            _moves      = 1;
            _health     = 50;
            _mana       = 100;
            break;
        case kGWCharacterTypeThief:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeLine3;
            _maxMoves   = 2;
            _moves      = 2;
            _health     = 100;
            _mana       = 50;
            break;
        case kGWCharacterTypePriest:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeLeftSquigly;
            _maxMoves   = 1;
            _moves      = 1;
            _health     = 70;
            _mana       = 80;
            break;
        default:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaType3x3Square;
            _maxMoves   = 1;
            _moves      = 1;
            _health     = 100;
            _mana       = 100;
            break;
    }
    
    return self;
}

- (void)damage:(NSUInteger)dmg {
    if ((int)_health - (int)dmg >= 0) {
        _health -= dmg;
    } else {
        _health = 0;
        [self died];
    }
}

- (void)died {
    NSLog(@"Character died");
}

- (void)resetMoves {
    _moves = _maxMoves;
}

- (void)moved {
    --_moves;
}

- (NSString *)characterClass {
    
    NSString *characterClass = @"";
    
    switch (_type) {
        case kGWCharacterTypeWarrior:
            characterClass = @"Warrior";
            break;
        case kGWCharacterTypeArcher:
            characterClass = @"Archer";
            break;
        case kGWCharacterTypeMage:
            characterClass = @"Mage";
            break;
        case kGWCharacterTypePriest:
            characterClass = @"Priest";
            break;
        case kGWCharacterTypeThief:
            characterClass = @"Thief";
            break;
        default:
            break;
    }
    
    return characterClass;
}

@end
