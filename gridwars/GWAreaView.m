//
//  GWAreaView.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWAreaView.h"
#import "GWGridCoordinate.h"
#import "GWGridPieceCharacterView.h"
#import "GWGridPieceCharacter.h"
#import "UIView+Shapes.h"

@implementation GWAreaView {
    GWGridPieceCharacterView *_characterPieceView;
    CGFloat _tileWidth;
    CGFloat _tileHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    // Drawing code
    _tileWidth = self.frame.size.width / 3;
    _tileHeight = self.frame.size.height / 3;
    [self setBackgroundColor:[UIColor whiteColor]];
    return self;
}

- (void)setCoordinates:(NSArray *)coordinates {
    _coordinates = coordinates;
    [self setNeedsDisplay];
}

- (void)setCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    if (_characterPieceView) [_characterPieceView removeFromSuperview];
    _characterPiece = characterPiece;
    _characterPieceView = [[GWGridPieceCharacterView alloc] initWithFrame:CGRectMake(1 * _tileWidth, 1 * _tileHeight, _tileWidth, _tileHeight) withCharacterPiece:_characterPiece];
    [self addSubview:_characterPieceView];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Draw grid
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            CGRect tileRect = CGRectMake(i * _tileWidth, j * _tileHeight, _tileWidth, _tileHeight);
            [self drawRectangle:tileRect withFillColor:[UIColor whiteColor] withStrokeColor:[UIColor blackColor]];
        }
    }
    
    // Draw tiles
    for (GWGridCoordinate *coordinate in _coordinates) {
        CGRect tileRect = CGRectMake((coordinate.col + 1) * _tileWidth, (coordinate.row + 1) * _tileHeight, _tileWidth, _tileHeight);
        [self drawRectangle:tileRect withFillColor:[UIColor redColor] withStrokeColor:[UIColor blackColor]];
    }
}


@end
