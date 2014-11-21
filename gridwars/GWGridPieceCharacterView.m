//
//  GWGridPieceCharacterView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-13.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWGridPieceCharacterView.h"
#import "GWGridPieceCharacter.h"
#import "GWCharacter.h"
#import "GWPlayer.h"
#import "GWHealthBar.h"
#import "UIView+Shapes.h"
#import "NSObject+KVOBlocks.h"

@implementation GWGridPieceCharacterView {
    UIImageView *_characterImage;
    GWHealthBar *_healthBar;
    UIView *_overlay;
    UILabel *_title;
}

- (id)initWithFrame:(CGRect)frame withCharacterPiece:(GWGridPieceCharacter *)characterPiece
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _characterPiece = characterPiece;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:NO];

    _characterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:characterPiece.character.image]];
    _characterImage.frame = CGRectMake(self.frame.size.width / 2 - _characterImage.bounds.size.width / 2, self.frame.size.height - _characterImage.bounds.size.height - 3.0f, CGRectGetWidth(_characterImage.frame), CGRectGetHeight(_characterImage.frame));
    [self addSubview:_characterImage];
    
    _healthBar = [[GWHealthBar alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 8.0f, self.frame.size.width, 8.0f)];
    [self addSubview:_healthBar];
    
    _overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _overlay.layer.borderWidth = 2.0f;
    _overlay.layer.cornerRadius = 4.0f;
    _overlay.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:_overlay];
    
    _title = [[UILabel alloc] initWithFrame:_overlay.frame];
    _title.font = [UIFont systemFontOfSize:9.0f];
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.text = @"";
    _title.numberOfLines = 2;
    [self addSubview:_title];
    
    return self;
}

- (void)updateHealthBarUI {
    [_healthBar setPercentage:(float)_characterPiece.character.health / _characterPiece.character.maxHealth];
}

- (void)runDyingAnimationWithCompletionBlock:(dispatch_block_t)block {
    [UIView animateWithDuration:1.0f animations:^{
        self.frame = CGRectOffset(self.frame, 0.0f, 10.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        if (block) block();
    }];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing circle
    UIColor *fillColor;
    [_overlay setBackgroundColor:[UIColor clearColor]];
    _title.text = @"";
    
    if (_characterPiece.character.owner.playerNumber == kGWPlayer1) {
        fillColor = [UIColor colorWithRed:255.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:0.8f];
    } else if (_characterPiece.character.owner.playerNumber == kGWPlayer2) {
        fillColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:255.0f/255.0f alpha:0.8f];
    }
    
    if (_characterPiece.character.actions <= 0) {
        [_overlay setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
        _title.text = @"No Moves";
    }
    
    switch (_characterPiece.state) {
        case kGWGridPieceCharacterStateClaimingTerritory:
            [_overlay setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
            _title.text = @"Claiming";
            break;
            
        default:
            break;
    }
    
    [self drawCircle:CGRectMake(rect.origin.x + 1.0f, rect.origin.y + 1.0f, rect.size.width - 2.0f, rect.size.height - 2.0f) withFillColor:fillColor withStrokeColor:[UIColor blackColor]];
}


@end
