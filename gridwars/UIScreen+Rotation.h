//
//  UIScreen+Rotation.h
//  Athos
//
//  Created by Anders Borch on 7/22/14.
//  Copyright (c) 2014 Anders Borch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Rotation)

/**
 * Returns screen boundaries matching the current device
 * orientation.
 */
@property (nonatomic,readonly) CGRect orientationRelativeBounds;

@end
