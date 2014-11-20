//
//  ViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-09.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "ViewController.h"
#import "GWGameViewController.h"
#import "GWGrid.h"
#import "GWPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create grid
    GWGrid *grid = [[GWGrid alloc] init];
    grid.tileSize = CGSizeMake(37.5f, 37.5f);
    [grid gridWithNumHorTiles:8 withNumVertTile:10];
    
    GWPlayer *player = [[GWPlayer alloc] init];
    GWPlayer *enemy = [[GWPlayer alloc] init];
    
    GWGameViewController *game = [[GWGameViewController alloc] initWithPlayer:player withEnemy:enemy withGrid:grid];
    [self addChildViewController:game];
    [self.view addSubview:game.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
