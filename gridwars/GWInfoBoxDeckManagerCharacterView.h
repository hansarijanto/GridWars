//
//  GWInfoBoxDeckManagerCharacterView.h
//  gridwars
//
//  Created by Hans Arijanto on 11/23/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWInfoBoxView.h"

@class GWCharacter;

@interface GWInfoBoxDeckManagerCharacterView : GWInfoBoxView

- (id)initWithFrame:(CGRect)frame withCharacter:(GWCharacter *)character;
@property(nonatomic, strong)UIButton *leaderButton;

@end
