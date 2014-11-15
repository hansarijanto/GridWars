//
//  GWDeckViewCell.h
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWDragableView.h"

@class GWDeckCell;

@interface GWDeckCellView : GWDragableView

@property(nonatomic, strong)GWDeckCell *cellData;

- (instancetype)initWithFrame:(CGRect)frame withCell:(GWDeckCell *)cellData;

@end
