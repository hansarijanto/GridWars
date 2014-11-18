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
#import "GWHealthBar.h"
#import "UIView+Shapes.h"
#import "NSObject+KVOBlocks.h"

@implementation GWGridPieceCharacterView {
    UIImageView *_characterImage;
    GWHealthBar *_healthBar;
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
    
    return self;
}

- (void)updateHealthBarUI {
    [_healthBar setPercentage:(float)_characterPiece.character.health / _characterPiece.character.maxHealth];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing circle
    UIColor *fillColor = [UIColor redColor];
    
//    switch (_characterPiece.character.type) {
//        case kGWCharacterTypeWarrior:
//            fillColor = [UIColor redColor];
//            break;
//        case kGWCharacterTypeArcher:
//            fillColor = [UIColor greenColor];
//            break;
//        case kGWCharacterTypeMage:
//            fillColor = [UIColor blueColor];
//            break;
//        case kGWCharacterTypePriest:
//            fillColor = [UIColor purpleColor];
//            break;
//        case kGWCharacterTypeThief:
//            fillColor = [UIColor blackColor];
//            break;
//            
//        default:
//            break;
//    }
    
    if (_characterPiece.character.actions <= 0) {
        self.alpha = 0.5f;
    } else {
        self.alpha = 1.0f;
    }
    
    [self drawCircle:CGRectMake(rect.origin.x + 1.0f, rect.origin.y + 1.0f, rect.size.width - 2.0f, rect.size.height - 2.0f) withFillColor:fillColor withStrokeColor:[UIColor blackColor]];
}


@end
