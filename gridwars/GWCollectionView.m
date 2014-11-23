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

@implementation GWCollectionView

- (instancetype)initWithFrame:(CGRect)frame withCells:(NSArray *)cells withOptions:(struct CollectionViewOptions)options {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    CGFloat width = options.colPerRow * options.cellWidth + (options.colPerRow - 1) * options.horSpacing;
    CGFloat height = ([cells count] / options.colPerRow) * options.cellHeight + (([cells count] / options.colPerRow) - 1) * options.vertSpacing;
    
    self.contentSize = CGSizeMake(width, height);
    
    // x cols per row
    for (int i=0; i<[cells count]; ++i) {
        
        GWCollectionCellView *cell = cells[i];
        
        int row = i / options.colPerRow;
        int col = i % options.colPerRow;
        
        cell.frame = CGRectMake(col * (options.horSpacing + options.cellWidth), row * (options.cellHeight + options.vertSpacing), options.cellWidth, options.cellHeight);
        
        [self addSubview:cell];
    }
    
    return self;
}

@end
