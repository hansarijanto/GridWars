//
//  DictionarySerializable.h
//
//  Created by Anders Borch on 5/10/12.
//  Copyright (c) 2012 Anders Borch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionarySerializable : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)dictionaryValue;
- (NSString *)jsonValue;
@end
