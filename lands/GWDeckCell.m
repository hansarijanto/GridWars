//
//  GWDeckCell.m
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWDeckCell.h"
#import "GWCharacter.h"
#import "GWGridPieceCharacter.h"

@implementation GWDeckCell

- (instancetype)initWithCharacter:(GWCharacter *)character {
    self = [super init];
    if (!self) return nil;
    
    _character = character;
    _characterPiece = [[GWGridPieceCharacter alloc] initWithCharacter:character];
    _type = kGWDeckCellTypeCharacter;
    
    return self;
}
@end
