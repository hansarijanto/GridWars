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
    
    return self;
}

- (void)addCharacter:(GWCharacter *)character {
    character.owner = self;
    [((NSMutableArray *)_characters) addObject:character];
}

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

@end
