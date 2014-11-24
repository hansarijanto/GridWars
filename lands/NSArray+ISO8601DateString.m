//
//  NSArray+ISO8601DateString.m
//  Athos
//
//  Created by Hans Arijanto on 10/9/14.
//  Copyright (c) 2014 Athos. All rights reserved.
//

#import "NSArray+ISO8601DateString.h"
#import "NSDictionary+ISO8601DateString.h"
#import "NSDate+Timezone.h"

@implementation NSArray (ISO8601DateString)
-(NSArray *)arrayWithISO8601DateString
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self count]; ++i) {
        NSObject *object=self[i];
        
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
            array[i] = [(NSArray *)object arrayWithISO8601DateString];
        } else if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            array[i] = [(NSDictionary *)object dictionaryWithISO8601DateString];
        } else if ([object isKindOfClass:[NSDate class]]) {
            NSString *result = [(NSDate *)object iso8601];
            array[i] = result;
        } else {
            array[i] = object;
        }
    }
    return array;
}
@end