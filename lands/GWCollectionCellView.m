//
//  GWCharacterStoreCellView.m
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCollectionCellView.h"
#import "GWCharacter.h"
#import "GWButton.h"

@implementation GWCollectionCellView {
    UIImageView *_playerSprite;
}

- (instancetype)initWithFrame:(CGRect)frame withCharacter:(GWCharacter *)character {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _character = character;
    
    [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
    self.layer.cornerRadius  = 10.0f;
    self.layer.masksToBounds = YES;
    self.showsTouchWhenHighlighted = YES;
    
    _playerSprite = [[UIImageView alloc] initWithFrame:CGRectZero];
    _playerSprite.image = [UIImage imageNamed:character.image];
    _playerSprite.contentMode = UIViewContentModeCenter;
    [self addSubview:_playerSprite];
    
    _button = [[GWButton alloc] initWithFrame:CGRectZero];
    _button.layer.cornerRadius = 0.0f;
    [self addSubview:_button];
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _playerSprite.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    _button.frame = CGRectMake(0.0f, frame.size.height - 30.0f, frame.size.width, 30.0f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
