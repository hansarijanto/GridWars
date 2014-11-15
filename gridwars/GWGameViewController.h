//
//  GWGameViewController.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGridTile;

@interface GWGameViewController : UIViewController

@property(nonatomic, strong, readonly) NSDictionary *characters; // CharacterPiece with character uuid as its key

@end
