//
//  GWGridResponse.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-16.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWGridResponse : NSObject

@property(nonatomic, readonly) BOOL success;
@property(nonatomic, strong, readonly) NSString *message;

- (instancetype)initWithSuccess:(BOOL)success withMessage:(NSString *)message;

@end
