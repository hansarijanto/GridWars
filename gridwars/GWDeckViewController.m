//
//  GWDeckViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 11/13/14.
//  Copyright (c) 2014 ARJ Games. All rights reserved.
//

#import "GWDeckViewController.h"
#import "GWDeckCell.h"
#import "GWDeckCellView.h"
#import "GWGridPieceCharacter.h"

@interface GWDeckViewController ()

@end

@implementation GWDeckViewController {
    CGFloat _leftPadding;
    CGFloat _topPadding;
    CGFloat _width;
    CGFloat _height;
    
    CGFloat _cellSidePadding;
    CGFloat _cellSpacing;
    CGFloat _cellTopPadding;
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

- (instancetype)initWithCellViews:(NSArray *)cellViews {
    self = [super init];
    if (!self) return nil;

    _leftPadding = 10.0f;
    _topPadding = 413.0f;
    _width = 300.0f;
    _height = 47.5f;

    _cellSidePadding = 5.0f;
    _cellSpacing = 5.0f;
    _cellTopPadding = 5.0f;
    _cellWidth = 37.5f;
    _cellHeight = 37.5f;
    
    // Set cell views
    _cellViews = cellViews;

    // Create scrool view
    UIScrollView *scrollContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(_leftPadding, _topPadding, _width, _height)];
    NSUInteger numCells = [cellViews count];
    scrollContainer.contentSize = CGSizeMake(_cellSidePadding * 2 + numCells * _cellWidth + (numCells - 1) * _cellSpacing, _height);

    // Create and add cell views to container
    NSUInteger cellNum = 0;
    for (GWDeckCellView *cellView in _cellViews) {
        cellView.frame = CGRectMake(_cellSidePadding + cellNum * (_cellWidth + _cellSpacing), _cellTopPadding, _cellWidth, _cellHeight);
        [scrollContainer addSubview:cellView];
        cellNum++;
    }
    _cellViews = cellViews;
    
    [scrollContainer setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    self.view = scrollContainer;
    
    // Allow cells to be dragged outside of scrollContainer
    scrollContainer.clipsToBounds = NO;
    
    return self;
}

- (CGPoint)convertToOnScreenLocation:(CGPoint)location {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    return CGPointMake(location.x + scrollView.frame.origin.x - scrollView.contentOffset.x, location.y + scrollView.frame.origin.y);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
