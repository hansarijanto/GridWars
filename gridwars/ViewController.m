//
//  ViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "ViewController.h"
#import "GWGameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GWGameViewController *game = [[GWGameViewController alloc] init];
    [self addChildViewController:game];
    [self.view addSubview:game.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
