//
//  GWGridTileOverlayView.h
//  gridwars
//
//  Created by Hans Arijanto on 11/20/14.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GWGridTile;

@interface GWGridTileOverlayView : UIView

@property(nonatomic, strong)GWGridTile *tile;

- (id)initWithFrame:(CGRect)frame withTile:(GWGridTile *)tile;


@end
