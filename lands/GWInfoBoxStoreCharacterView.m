//
//  GWInfoBoxStoreCharacterView.m
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWInfoBoxStoreCharacterView.h"
#import "GWCharacter.h"

@implementation GWInfoBoxStoreCharacterView {
    UILabel *_classLabel;
    UILabel *_healthLabel;
    UILabel *_actionsLabel;
    
    float _leftPadding;
}

- (id)initWithFrame:(CGRect)frame withCharacter:(GWCharacter *)character
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _leftPadding = 10.0f;
        UIFont *systemFont = [UIFont systemFontOfSize:13.0f];
        
        _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 5.0f, 0.0f, 0.0f)];
        _classLabel.text = [NSString stringWithFormat:@"Class: %@", character.characterClass];
        _classLabel.textColor = [UIColor whiteColor];
        _classLabel.font = systemFont;
        [_classLabel sizeToFit];
        [self addSubview:_classLabel];
        
        _healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 20.0f, 0.0f, 0.0f)];
        _healthLabel.text = [NSString stringWithFormat:@"Max Health: %li", (long)character.maxHealth];
        _healthLabel.textColor = [UIColor whiteColor];
        _healthLabel.font = systemFont;
        [_healthLabel sizeToFit];
        [self addSubview:_healthLabel];
        
        _actionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 35.0f, 0.0f, 0.0f)];
        _actionsLabel.text = [NSString stringWithFormat:@"Max Actions: %li", (long)character.maxActions];
        _actionsLabel.textColor = [UIColor whiteColor];
        _actionsLabel.font = systemFont;
        [_actionsLabel sizeToFit];
        [self addSubview:_actionsLabel];
    }
    return self;
}

@end
