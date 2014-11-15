//
//  GWGridInfoBoxViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWInfoBoxViewController.h"
#import "GWInfoBoxCharacterView.h"
#import "GWGridPieceCharacter.h"
#import "GWAreaView.h"
#import "UIButton+Block.h"

@interface GWInfoBoxViewController ()

@end

@implementation GWInfoBoxViewController {
    float _sidePadding;
    GWGridPieceCharacter *_characterPiece;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self clearView];
    
    return self;
}

- (void)reloadData {
    if ([self.view isMemberOfClass:[GWInfoBoxCharacterView class]]) {
        [self setViewForCharacterPiece:_characterPiece];
    }
}

- (void)setViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    _characterPiece = characterPiece;
    GWInfoBoxCharacterView *characterInfoBoxView = [[GWInfoBoxCharacterView alloc] initWithFrame:self.view.frame withCharacterPiece:characterPiece];
    characterInfoBoxView.areaView.coordinates = _characterPiece.summoningTileCoordinatesForAreaView;
    
    __weak GWInfoBoxViewController *weak = self;
    __weak GWGridPieceCharacter *weakCharacterPiece = _characterPiece;
    
    UIButtonBlock rotateBlock = ^(id sender, UIEvent *event) {
        
        GWInfoBoxViewController *strong = weak;
        GWGridPieceCharacter *strongCharacterPiece = weakCharacterPiece;
        
        [_characterPiece rotate];
        for (GWGridCoordinate *coor in strongCharacterPiece.summoningTileCoordinatesForAreaView) {
            NSLog(@"%i, %i",coor.row, coor.col);
        }

        ((GWInfoBoxCharacterView *)strong.view).areaView.coordinates = strongCharacterPiece.summoningTileCoordinatesForAreaView;
    };
    [characterInfoBoxView.rotateButton addTarget:self withBlock:rotateBlock forControlEvents:UIControlEventTouchUpInside];
    self.view = characterInfoBoxView;
}

- (void)clearView {
    self.view = [[GWInfoBoxView alloc] initWithFrame:CGRectMake(10.0f, 470.0f, 300.0f, 90.0f)];
}


@end
