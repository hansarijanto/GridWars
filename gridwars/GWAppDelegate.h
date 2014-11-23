//
//  AppDelegate.h
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWRootViewController;

@interface GWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (GWRootViewController*)rootViewController;
+ (GWAppDelegate*)sharedAppDelegate;

@end
