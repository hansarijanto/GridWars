//
//  GWGridResponse.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-16.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGWGridResponseTypeCharacterDied,
    kGWGridResponseTypeUknown,
    kGWGridResponseTypeActionNotCharacterTurn,
    kGWGridResponseTypeActionNoMovesLeft,
    kGWGridResponseTypeActionClaimingTerritory,
    kGWGridResponseTypeSummonSuccessful,
    kGWGridResponseTypeSummonNotCharacterTurn,
    kGWGridResponseTypeSummonOutsideTerritory,
    kGWGridResponseTypeSummonOnFilledTile,
} kGWGridResponseType;

@interface GWGridResponse : NSObject

@property(nonatomic, readonly) BOOL success;
@property(nonatomic, readonly) kGWGridResponseType type;
@property(nonatomic, strong, readonly) NSString *message;

- (instancetype)initWithSuccess:(BOOL)success withMessage:(NSString *)message withStatus:(kGWGridResponseType)type;

@end
