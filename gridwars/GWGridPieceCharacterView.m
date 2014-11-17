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
#import "UIView+Shapes.h"

@implementation GWGridPieceCharacterView {
    UIFont *_classFont;
    UIImageView *_characterImage;
}

- (id)initWithFrame:(CGRect)frame withCharacterPiece:(GWGridPieceCharacter *)characterPiece
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _characterPiece = characterPiece;
    _classFont = [UIFont systemFontOfSize:10.0f];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:NO];
    
    _characterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:characterPiece.character.image]];
    [self addSubview:_characterImage];
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing circle
    UIColor *fillColor = [UIColor whiteColor];
    
    switch (_characterPiece.character.type) {
        case kGWCharacterTypeWarrior:
            fillColor = [UIColor redColor];
            break;
        case kGWCharacterTypeArcher:
            fillColor = [UIColor greenColor];
            break;
        case kGWCharacterTypeMage:
            fillColor = [UIColor blueColor];
            break;
        case kGWCharacterTypePriest:
            fillColor = [UIColor purpleColor];
            break;
        case kGWCharacterTypeThief:
            fillColor = [UIColor blackColor];
            break;
            
        default:
            break;
    }
    
    if (_characterPiece.character.moves <= 0) {
        self.alpha = 0.5f;
    } else {
        self.alpha = 1.0f;
    }
    
    [self drawCircle:CGRectMake(rect.origin.x + 1.0f, rect.origin.y + 1.0f, rect.size.width - 2.0f, rect.size.height - 2.0f) withFillColor:fillColor withStrokeColor:[UIColor blackColor]];
    
    // Drawing class
//    CGRect classRect = CGRectMake(0.0f, rect.size.height / 2 - _classFont.pointSize / 2, rect.size.width, rect.size.height);
//    UIColor *white = [UIColor whiteColor];
//    NSDictionary *stringAttrs = @{ NSFontAttributeName : _classFont, NSForegroundColorAttributeName : white };
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[_characterPiece.character.characterClass substringToIndex:1] attributes:stringAttrs];
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setAlignment:NSTextAlignmentCenter];
//    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
//    [attrStr drawInRect:classRect];
}


@end
