//
//  GWGridCell.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Shapes.h"

@interface GWGridCoordinate : NSObject

@property(nonatomic, readonly) int row;
@property(nonatomic, readonly) int col;

- (void)moveTo:(CGPoint)dest;
- (instancetype)initWithRow:(int)row withCol:(int)col;

@end
