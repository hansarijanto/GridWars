//
//  GWUser.h
//  gridwars
//
//  Created by Hans Arijanto on 11/19/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGWUser1
} GWUserNumber;

@interface GWUser : NSObject

@property(nonatomic, readwrite) GWUserNumber userNumber;

@end
