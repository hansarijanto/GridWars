//
//  GWGridPiece.m
//  gridwars
//
//  Created by Hans Arijanto on 11/11/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWGridPiece.h"
#import "GWGridPieceCharacter.h"

@implementation GWGridPiece

- (BOOL)isCharacter {
    return [self isMemberOfClass:[GWGridPieceCharacter class]];
}

@end
