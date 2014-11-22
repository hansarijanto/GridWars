//
//  GWInfoBoxStoreCharacterView.h
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWInfoBoxView.h"

@class GWCharacter;

@interface GWInfoBoxStoreCharacterView : GWInfoBoxView

- (id)initWithFrame:(CGRect)frame withCharacter:(GWCharacter *)character;

@end
