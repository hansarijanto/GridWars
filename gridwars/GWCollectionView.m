//
//  GWCollectionView.m
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWCollectionView.h"
#import "GWCollectionCellView.h"

@interface GWCollectionView ()

@end

@implementation GWCollectionView {
    struct CollectionViewOptions _options;
}

- (instancetype)initWithFrame:(CGRect)frame withCells:(NSArray *)cells withOptions:(struct CollectionViewOptions)options {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _options = options;
    self.cells = cells;
    
    return self;
}

- (void)setCells:(NSArray *)cells {
    for (GWCollectionCellView *cellView in _cells) {
        [cellView removeFromSuperview];
    }
    
    _cells = cells;
    
    int totalCol = _options.colPerRow;
    if ([_cells count] < totalCol) totalCol = [_cells count];
    
    int totalRow = (([_cells count] - 1) / _options.colPerRow) + 1;
    
    CGFloat width;
    if (totalCol > 0) width = totalCol * _options.cellWidth + (totalCol - 1) * _options.horSpacing;
    else width = 0.0f;
    
    CGFloat height;
    if (totalRow > 0) height = totalRow * _options.cellHeight + (totalRow - 1) * _options.vertSpacing;
    else height = 0.0f;
    
    self.contentSize = CGSizeMake(width, height);
    
    // x cols per row
    for (int i=0; i<[_cells count]; ++i) {
        
        GWCollectionCellView *cell = _cells[i];
        
        int row = i / _options.colPerRow;
        int col = i % _options.colPerRow;
        
        cell.frame = CGRectMake(col * (_options.horSpacing + _options.cellWidth), row * (_options.cellHeight + _options.vertSpacing), _options.cellWidth, _options.cellHeight);
        
        [self addSubview:cell];
    }
}

@end
