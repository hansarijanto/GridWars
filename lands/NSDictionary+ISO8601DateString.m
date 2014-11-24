//
//  NSDictionary+ISO8601DateString.m
//  Athos
//
//  Created by Hans Arijanto on 10/9/14.
//  Copyright (c) 2014 Athos. All rights reserved.
//

#import "NSDictionary+ISO8601DateString.h"
#import "NSArray+ISO8601DateString.h"
#import "NSDate+Timezone.h"

@implementation NSDictionary (ISO8601DateString)

-(NSDictionary *)dictionaryWithISO8601DateString
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    
    for(id key in self)
    {
        NSObject *object=[self objectForKey:key];
        
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
            [dictionary setObject:[(NSArray *)object arrayWithISO8601DateString] forKey:key];
        } else if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            [dictionary setObject:[(NSDictionary *)object dictionaryWithISO8601DateString] forKey:key];
        } else if ([object isKindOfClass:[NSDate class]]) {
           // crashes for some reason, can't track
            //NSString *result = [((NSDate *)object) iso8601];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSString* dateStr = [dateFormatter stringFromDate:(NSDate *)object];
            
            [dictionary setObject:dateStr forKey:key];
        } else {
            [dictionary setObject:object forKey:key];

        }
    }
    return dictionary;
}

@end