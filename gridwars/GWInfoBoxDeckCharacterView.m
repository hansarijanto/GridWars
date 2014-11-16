//
//  GWGridInfoBoxCharacterView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWInfoBoxDeckCharacterView.h"
#import "GWCharacter.h"
#import "GWGrid.h"
#import "GWGridPieceCharacter.h"
#import "GWAreaView.h"

@implementation GWInfoBoxDeckCharacterView {
    UILabel *_classLabel;
    UILabel *_positionLabel;
    UILabel *_healthLabel;
    UILabel *_manaLabel;
    UILabel *_movesLabel;
    
    float _leftPadding;
}

- (id)initWithFrame:(CGRect)frame withCharacterPiece:(GWGridPieceCharacter *)characterPiece
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _leftPadding = 10.0f;
        UIFont *systemFont = [UIFont systemFontOfSize:13.0f];
        
        _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 5.0f, 0.0f, 0.0f)];
        _classLabel.text = [NSString stringWithFormat:@"Class: %@", characterPiece.character.characterClass];
        _classLabel.textColor = [UIColor whiteColor];
        _classLabel.font = systemFont;
        [_classLabel sizeToFit];
        [self addSubview:_classLabel];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 20.0f, 0.0f, 0.0f)];
        _positionLabel.text = [NSString stringWithFormat:@"Row: %i Col: %i", characterPiece.row, characterPiece.col];
        _positionLabel.textColor = [UIColor whiteColor];
        _positionLabel.font = systemFont;
        [_positionLabel sizeToFit];
        [self addSubview:_positionLabel];
        
        _healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 35.0f, 0.0f, 0.0f)];
        _healthLabel.text = [NSString stringWithFormat:@"Health: %li", (long)characterPiece.character.health];
        _healthLabel.textColor = [UIColor whiteColor];
        _healthLabel.font = systemFont;
        [_healthLabel sizeToFit];
        [self addSubview:_healthLabel];
        
        _manaLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 50.0f, 0.0f, 0.0f)];
        _manaLabel.text = [NSString stringWithFormat:@"Mana: %li", (long)characterPiece.character.mana];
        _manaLabel.textColor = [UIColor whiteColor];
        _manaLabel.font = systemFont;
        [_manaLabel sizeToFit];
        [self addSubview:_manaLabel];
        
        _movesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 65.0f, 0.0f, 0.0f)];
        _movesLabel.text = [NSString stringWithFormat:@"Moves Left: %lu", (long)characterPiece.character.moves];
        _movesLabel.textColor = [UIColor whiteColor];
        _movesLabel.font = systemFont;
        [_movesLabel sizeToFit];
        [self addSubview:_movesLabel];
        
        CGFloat areaWidth = self.frame.size.height - 10.0f;
        _areaView = [[GWAreaView alloc] initWithFrame:CGRectMake(self.frame.size.width - _leftPadding - areaWidth, 5.0f, areaWidth, areaWidth)];
        [self addSubview:_areaView];
        
        _rotateButton = [[UIButton alloc] initWithFrame:CGRectMake(210.0f - 40.0f - 35.0f, 10.0f, 40.0f, 30.0f)];
        [_rotateButton setBackgroundColor:[UIColor whiteColor]];
        [_rotateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rotateButton setTitle:@"Rotate" forState:UIControlStateNormal];
        _rotateButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _rotateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rotateButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
