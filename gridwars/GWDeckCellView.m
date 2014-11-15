//
//  GWDeckViewCell.m
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWDeckCellView.h"
#import "GWDeckCell.h"
#import "GWGridPieceCharacterView.h"

@implementation GWDeckCellView {
    UIView *_content;
}

- (instancetype)initWithFrame:(CGRect)frame withCell:(GWDeckCell *)cellData {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _cellData = cellData;
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_cellData.type == kGWDeckCellTypeCharacter) {
        if (_content) [_content removeFromSuperview];
        _content = [[GWGridPieceCharacterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height) withCharacterPiece:_cellData.characterPiece];
        [self addSubview:_content];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
