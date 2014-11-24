//
//  DictionarySerializable.m
//
//  Created by Anders Borch on 5/10/12.
//  Copyright (c) 2012 Anders Borch. All rights reserved.
//

#import <objc/runtime.h>
#import "DictionarySerializable.h"
#import "NSArray+ISO8601DateString.h"
#import "NSDictionary+ISO8601DateString.h"
#import "GWPlayer.h"

@implementation DictionarySerializable

- (NSMethodSignature*)cachedSignatureFromString:(NSString*)string withSelector:(SEL)selector {
    static NSMutableDictionary *cache = nil;
    NSMutableDictionary *classCache;
    if (!cache) cache = [NSMutableDictionary dictionary];
    classCache = [cache objectForKey: [[self class] description]];
    if (!classCache) {
        classCache = [NSMutableDictionary dictionary];
        [cache setObject: classCache
                  forKey: [[self class] description]];
    }
    NSMethodSignature *signature = [classCache objectForKey: string];
    if (!signature) {
        signature = [self methodSignatureForSelector: selector];
        [classCache setObject: signature
                       forKey: string];
    }
    return signature;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        for (NSString *key in [dictionary allKeys]) {
            @try {
                // Get the information about the property matching the key
                objc_property_t property = class_getProperty([self class], [key UTF8String]);
                if (!property) {
                    // No property with that name declared - skip it
                    NSLog(@"skipping property %@ on %@", key, [[self class] description]);
                    continue;
                }
                // For a property named 'someProperty' assume that the setter is named 'setSomeProperty'
                NSString *setter = [NSString stringWithFormat: @"set%@%@:", [[key substringToIndex: 1] uppercaseString], [key substringFromIndex: 1]];
                const char *attributes = property_getAttributes(property);
                // Iterate through the property attributes and look for a custom setter name
                for (NSString *component in [[NSString stringWithFormat:@"%s", attributes] componentsSeparatedByString: @","]) {
                    if ([component hasPrefix: @"S"]) {
                        // If a custom setter name is specified then use that in stead of the default setter name
                        setter = [component substringFromIndex: 1];
                    }
                }
                // Build an invocation for the setter
                SEL selector = NSSelectorFromString(setter);
                NSMethodSignature *signature = [self cachedSignatureFromString: setter withSelector: selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: signature];
                
                [invocation setSelector: selector];
                [invocation setTarget: self];
                int value;
                long long qvalue;
                float fvalue;
                double dvalue;
                id ivalue;
                switch (attributes[1]) {
                    case 'c': // char
                    case 'i': // int
                    case 'l': // long
                    case 's': // short
                    case 'I': // unsigned int
                    case '^': // pointer
                        if ([[dictionary objectForKey: key] isMemberOfClass: [NSNull class]]) {
                            value = 0;
                        } else {
                            value = [[dictionary objectForKey: key] intValue];
                        }
                        [invocation setArgument: (void*)&value
                                        atIndex: 2];
                        break;
                    case 'q': // long long
                    case 'Q':
                        if ([[dictionary objectForKey: key] isMemberOfClass: [NSNull class]]) {
                            qvalue = 0;
                        } else {
                            qvalue = [[dictionary objectForKey: key] longLongValue];
                        }
                        [invocation setArgument: (void*)&qvalue
                                        atIndex: 2];
                        break;
                    case 'd': // double
                        if ([[dictionary objectForKey: key] isMemberOfClass: [NSNull class]]) {
                            dvalue = 0.0;
                        } else {
                            dvalue = [[dictionary objectForKey: key] doubleValue];
                        }
                        [invocation setArgument: (void*)&dvalue
                                        atIndex: 2];
                        break;
                    case 'f': // float
                        if ([[dictionary objectForKey: key] isMemberOfClass: [NSNull class]]) {
                            fvalue = 0.0f;
                        } else {
                            fvalue = [[dictionary objectForKey: key] floatValue];
                        }
                        [invocation setArgument: (void*)&fvalue
                                        atIndex: 2];
                        break;
                    case '@': // id
                        ivalue = [dictionary objectForKey: key];
                        if (ivalue && ![ivalue isMemberOfClass: [NSNull class]]) {
                            [invocation setArgument: &ivalue
                                            atIndex: 2];
                        }
                        break;
                        
                    default:
                        [NSException raise: NSInvalidArgumentException
                                    format: @"Unsupported argument type: %c for property: %@", attributes[1], key];
                        break;
                }
                [invocation invoke];
            }
            @catch (NSException *exception) {
                NSLog(@"Error setting %@: %@", key, exception);
            }
        }
    }
    return self;
}

- (NSDictionary*)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    Class cls = [self class];
    /*
     Iterate over superclasses of self and get their properties,
     up to but not including DictionarySerializable.
     */
    while (strcmp(class_getName(cls),"DictionarySerializable")) {
        [dictionary addEntriesFromDictionary: [self dictionaryValueWithClass: cls]];
        cls = class_getSuperclass(cls);
    }
    return dictionary;
}

- (BOOL)shouldIncludeProperty:(NSString*)property {
    return YES;
}

- (NSDictionary*)dictionaryValueWithClass:(Class)cls {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    // Get a list of properties - we own this list and have to free it later
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    for (int c = 0 ; c < count ; c++) {
        // Get the name of the property (which by default is the property getter)
        objc_property_t property = properties[c];
        NSString *getter = [NSString stringWithFormat: @"%s", property_getName(property)];

        // Give subclasses an option to exclude properties from dictionary
        if (![self shouldIncludeProperty: getter]) continue;
        
        // Iterate through the property attributes and look for a custom getter name
        const char *attributes = property_getAttributes(property);
        for (NSString *component in [[NSString stringWithFormat:@"%s", attributes] componentsSeparatedByString: @","]) {
            if ([component hasPrefix: @"G"]) {
                // If a custom getter name is specified then use that in stead of the default getter name
                getter = [component substringFromIndex: 1];
            }
        }
        if ([getter  isEqualToString:@"hash"])
        {
            continue;
        }
        if ([getter  isEqualToString:@"superclass"])
        {
            continue;
        }
        if ([getter  isEqualToString:@"description"])
        {
            continue;
        }
        if ([getter  isEqualToString:@"debugDescription"])
        {
            continue;
        }
        
        // Build an invication for the getter
        NSMethodSignature *signature = [self methodSignatureForSelector: NSSelectorFromString(getter)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: signature];
        [invocation setSelector: NSSelectorFromString(getter)];
        [invocation setTarget: self];
        [invocation invoke];
        int value = 0;
        float fvalue = 0.0f;
        double dvalue = 0.0;
        long long qvalue = 0L;
        switch (attributes[1]) {
            case 'c': // char
            case 'i': // int
            case 'l': // long
            case 's': // short
            case 'I': // unsigned int
            case '^': // pointer
                [invocation getReturnValue: &value];
                [dictionary setObject: [NSNumber numberWithInt: value]
                               forKey: getter];
                break;
            case 'q': // long long
            case 'Q': // unsigned long long
                [invocation getReturnValue: &qvalue];
                [dictionary setObject: [NSNumber numberWithLongLong: qvalue]
                               forKey: getter];
                break;
            case 'd': // double
                [invocation getReturnValue: &dvalue];
                [dictionary setObject: [NSNumber numberWithDouble: dvalue]
                               forKey: getter];
                break;
            case 'f': // float
                [invocation getReturnValue: &fvalue];
                [dictionary setObject: [NSNumber numberWithFloat: fvalue]
                               forKey: getter];
                break;
            case '@': { // id
                void *ptr = NULL;
                [invocation getReturnValue: &ptr];
                if (ptr) {
                    [dictionary setObject: (__bridge id)ptr
                                   forKey: getter];
                }
                break;
            }
            default:
                /*[NSException raise: NSInvalidArgumentException
                            format: @"Unsupported argument type: %c", attributes[1]];*/
                NSLog(@"Unsupported argument type: %c for key %@", attributes[1],getter);
                break;
        }
    }
    free(properties);
    
    return  dictionary;
}

-(NSString *)jsonValue
{
    NSError *error;
    NSDictionary *safeDictionary=[[self dictionaryValue] dictionaryWithISO8601DateString];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:safeDictionary
                                                       options:0
                                                         error:&error];
    if (!jsonData)
    {
        NSLog(@"JSON error: %@", error);
        return @"";
    }
    
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    return JSONString;
}
@end
