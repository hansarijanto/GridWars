//
//  GWGridResponse.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-16.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridResponse.h"

@implementation GWGridResponse

- (instancetype)initWithSuccess:(BOOL)success withMessage:(NSString *)message withStatus:(kGWGridResponseType)type {
    self = [super init];
    if (!self) return nil;
    
    if (type) {
        _type = type;
    } else {
        _type = kGWGridResponseTypeUknown;
    }
    _success = success;
    _message = message;
    
    return self;
}

@end
