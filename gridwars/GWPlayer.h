//
//  GWPlayer.h
//  gridwars
//
//  Created by Hans Arijanto on 11/19/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGWUser1,
    kGWUser2
} GWUserNumber;

@interface GWPlayer : NSObject

@property(nonatomic, readwrite) GWUserNumber userNumber;
@property(nonatomic, readonly) NSArray *characters;

@end
