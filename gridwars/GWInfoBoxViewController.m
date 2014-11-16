//
//  GWGridInfoBoxViewController.m
//  gridwars
//
//  Created by Hans Arijanto on 2014-11-12.
//  Copyright (c) 2014 arjgames. All rights reserved.
//

#import "GWInfoBoxViewController.h"
#import "GWInfoBoxDeckCharacterView.h"
#import "GWInfoBoxGridCharacterView.h"
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

#pragma mark - GWInfoDeckViewForCharacterPiece

- (void)setDeckViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    _characterPiece = characterPiece;
    GWInfoBoxDeckCharacterView *characterInfoBoxView = [[GWInfoBoxDeckCharacterView alloc] initWithFrame:self.view.frame withCharacterPiece:characterPiece];
    characterInfoBoxView.areaView.coordinates = _characterPiece.summoningTileCoordinatesForAreaView;
    characterInfoBoxView.areaView.characterPiece = _characterPiece;
    
    __weak GWInfoBoxViewController *weak = self;
    __weak GWGridPieceCharacter *weakCharacterPiece = _characterPiece;
    
    UIButtonBlock rotateBlock = ^(id sender, UIEvent *event) {
        
        GWInfoBoxViewController *strong = weak;
        GWGridPieceCharacter *strongCharacterPiece = weakCharacterPiece;
        
        [_characterPiece rotate];
        for (GWGridCoordinate *coor in strongCharacterPiece.summoningTileCoordinatesForAreaView) {
            NSLog(@"%i, %i",coor.row, coor.col);
        }
        GWAreaView *areaView = ((GWInfoBoxDeckCharacterView *)strong.view).areaView;
        areaView.coordinates = strongCharacterPiece.summoningTileCoordinatesForAreaView;
    };
    [characterInfoBoxView.rotateButton addTarget:self withBlock:rotateBlock forControlEvents:UIControlEventTouchUpInside];
    self.view = characterInfoBoxView;
}

- (void)setRotateButtonHidden:(BOOL)hidden {
    if ([self.view isMemberOfClass:[GWInfoBoxDeckCharacterView class]]) {
        ((GWInfoBoxDeckCharacterView *)self.view).rotateButton.hidden = hidden;
    }
}

#pragma mark - GWInfoGridViewForCharacterPiece

- (void)setGridViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    _characterPiece = characterPiece;
    GWInfoBoxGridCharacterView *characterInfoBoxView = [[GWInfoBoxGridCharacterView alloc] initWithFrame:self.view.frame withCharacterPiece:characterPiece];
    self.view = characterInfoBoxView;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    if ([self.view isMemberOfClass:[GWInfoBoxGridCharacterView class]]) {
        ((GWInfoBoxGridCharacterView *)self.view).errorMessage.text = errorMessage;
    }
}

- (void)clearView {
    self.view = [[GWInfoBoxView alloc] initWithFrame:CGRectMake(10.0f, 470.0f, 300.0f, 90.0f)];
}


@end
