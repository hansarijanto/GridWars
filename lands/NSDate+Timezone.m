//
//  NSDate+Timezone.m
//  Athos
//
//  Created by Hans Arijanto on 10/14/14.
//  Copyright (c) 2014 Athos. All rights reserved.
//

#import "NSDate+Timezone.h"

@implementation NSDate (Timezone)

-(NSString *)iso8601 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString* dateStr = [dateFormatter stringFromDate:self];
    
    return dateStr;
}

@end
