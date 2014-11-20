//
//  GWCharacter.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCharacter.h"
#import "GWPlayer.h"

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
            _attackType = kGWAreaType3x3Square;
            _maxActions = 1;
            _actions    = 1;
            _health     = 150;
            _maxHealth  = 150;
            _attack     = 50;
            _image      = @"warrior";
            break;
        case kGWCharacterTypeArcher:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeRightSquigly;
            _attackType = kGWAreaType3x3Square;
            _maxActions = 1;
            _actions    = 1;
            _health     = 70;
            _maxHealth  = 70;
            _attack     = 30;
            _image      = @"archer";
            break;
        case kGWCharacterTypeMage:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeT;
            _attackType = kGWAreaType3x3Square;
            _maxActions = 1;
            _actions    = 1;
            _health     = 50;
            _maxHealth  = 50;
            _attack     = 50;
            _image      = @"mage";
            break;
        case kGWCharacterTypeThief:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeLine3;
            _attackType = kGWAreaType3x3Square;
            _maxActions = 2;
            _actions    = 2;
            _health     = 100;
            _maxHealth  = 100;
            _attack     = 30;
            _image      = @"thief";
            break;
        case kGWCharacterTypePriest:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaTypeLeftSquigly;
            _attackType = kGWAreaType3x3Square;
            _maxActions = 1;
            _actions    = 1;
            _health     = 70;
            _maxHealth  = 70;
            _attack     = 10;
            _image      = @"priest";
            break;
        default:
            _moveType   = kGWAreaTypeCross;
            _summonType = kGWAreaType3x3Square;
            _attackType = kGWAreaType3x3Square;
            _maxActions = 1;
            _actions    = 1;
            _health     = 100;
            _maxHealth  = 100;
            _attack     = 50;
            _image      = @"warrior";
            break;
    }
    
    return self;
}

- (void)damagedBy:(GWCharacter *)attacker {
    if (_health - attacker.attack >= 0) {
        _health -= attacker.attack;
    } else {
        _health = 0;
        [self died];
    }
}

- (void)died {
    NSLog(@"Character died");
}

- (void)resetMoves {
    _actions = _maxActions;
}

- (void)decrementActions {
    --_actions;
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
