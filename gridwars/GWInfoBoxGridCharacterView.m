//
//  GWInfoBoxGridCharacterView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-16.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWInfoBoxGridCharacterView.h"
#import "GWCharacter.h"
#import "GWGrid.h"
#import "GWGridPieceCharacter.h"
#import "GWAreaView.h"


@implementation GWInfoBoxGridCharacterView {
    UILabel *_classLabel;
    UILabel *_positionLabel;
    UILabel *_healthLabel;
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
        
        _movesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 50.0f, 0.0f, 0.0f)];
        _movesLabel.text = [NSString stringWithFormat:@"Moves Left: %lu", (long)characterPiece.character.actions];
        _movesLabel.textColor = [UIColor whiteColor];
        _movesLabel.font = systemFont;
        [_movesLabel sizeToFit];
        [self addSubview:_movesLabel];
        
        CGFloat errorMessageWidth = self.frame.size.height - 10.0f;
        _errorMessage = [[UITextView alloc] initWithFrame:CGRectMake(self.frame.size.width - _leftPadding - errorMessageWidth, 5.0f, errorMessageWidth, errorMessageWidth)];
        _errorMessage.textColor = [UIColor redColor];
        _errorMessage.textAlignment = NSTextAlignmentCenter;
        [_errorMessage setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_errorMessage];
        
        _claimButton = [[UIButton alloc] initWithFrame:CGRectMake(210.0f - 90.0f, 10.0f, 70.0f, 30.0f)];
        _claimButton.showsTouchWhenHighlighted = YES;
        [_claimButton setBackgroundColor:[UIColor blackColor]];
        [_claimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_claimButton setTitle:@"Claim" forState:UIControlStateNormal];
        _claimButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _claimButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _claimButton.layer.cornerRadius = 6.0f;
        [self addSubview:_claimButton];
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
