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
    
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    
    GWCharacter *warrior = [[GWCharacter alloc] initWithType:kGWCharacterTypeWarrior];
    GWCharacter *thief = [[GWCharacter alloc] initWithType:kGWCharacterTypeThief];
    GWCharacter *priest = [[GWCharacter alloc] initWithType:kGWCharacterTypePriest];
    GWCharacter *archer = [[GWCharacter alloc] initWithType:kGWCharacterTypeArcher];
    GWCharacter *mage = [[GWCharacter alloc] initWithType:kGWCharacterTypeMage];
    
    [characters addObject:warrior];
    [characters addObject:thief];
    [characters addObject:priest];
    [characters addObject:archer];
    [characters addObject:mage];
    
    _characters = (NSArray *)characters;
    
    return self;
}

@end
