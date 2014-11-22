//
//  GWCharacterStoreCellView.h
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWCharacter;

@interface GWCharacterStoreCellView : UIButton

@property(nonatomic, readonly)GWCharacter *character;
@property(nonatomic, readonly)UIButton *buyButton;

- (instancetype)initWithFrame:(CGRect)frame withCharacter:(GWCharacter *)character;

@end
