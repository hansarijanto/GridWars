//
//  GWGridTileView.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-13.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GWGridTile;

@interface GWGridTileView : UIView

@property(nonatomic, strong)GWGridTile *tile;

- (id)initWithFrame:(CGRect)frame withTile:(GWGridTile *)tile;

@end
