//
//  GWCollectionView.h
//  gridwars
//
//  Created by Hans Arijanto on 11/22/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

struct CollectionViewOptions {
    float horSpacing;
    float vertSpacing;
    float cellWidth;
    float cellHeight;
    int colPerRow;
};

@interface GWCollectionView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame withCells:(NSArray *)cells withOptions:(struct CollectionViewOptions)options;

@end
