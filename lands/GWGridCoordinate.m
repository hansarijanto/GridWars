//
//  GWGridCell.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridCoordinate.h"

@implementation GWGridCoordinate

- (instancetype)initWithRow:(int)row withCol:(int)col {
    self = [super init];
    if (!self) return nil;
    _row = row;
    _col = col;
    
    return self;
}

- (void)moveTo:(GWGridCoordinate *)coordinate {
    _row = coordinate.row;
    _col = coordinate.col;
}

@end
