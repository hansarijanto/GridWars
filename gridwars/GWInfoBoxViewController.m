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
#import "GWPlayer.h"
#import "GWCharacter.h"

@interface GWInfoBoxViewController ()

@end

@implementation GWInfoBoxViewController {
    float _sidePadding;
    GWGridPieceCharacter *_characterPiece;
    UIButtonBlock _endTurnBlock;
    UIButton *_endTurnButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (!self) return nil;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _endTurnButton = [[UIButton alloc] initWithFrame:CGRectMake(210.0f - 90.0f, 50.0f, 70.0f, 30.0f)];
    _endTurnButton.showsTouchWhenHighlighted = YES;
    [_endTurnButton setBackgroundColor:[UIColor blackColor]];
    [_endTurnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_endTurnButton setTitle:@"End Turn" forState:UIControlStateNormal];
    _endTurnButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _endTurnButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _endTurnButton.layer.cornerRadius = 6.0f;
    [self.view addSubview:_endTurnButton];
    
    self.infoBoxView = [[GWInfoBoxView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    
    return self;
}

#pragma mark - GWInfoDeckViewForCharacterPiece

- (void)setDeckViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece {
    _characterPiece = characterPiece;
    GWInfoBoxDeckCharacterView *characterInfoBoxView = [[GWInfoBoxDeckCharacterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) withCharacterPiece:characterPiece];
    characterInfoBoxView.areaView.coordinates = _characterPiece.summoningTileCoordinatesForAreaView;
    characterInfoBoxView.areaView.characterPiece = _characterPiece;
    
    __weak GWInfoBoxViewController *weak = self;
    __weak GWGridPieceCharacter *weakCharacterPiece = _characterPiece;
    
    UIButtonBlock rotateBlock = ^(id sender, UIEvent *event) {
        
        GWInfoBoxViewController *strong = weak;
        GWGridPieceCharacter *strongCharacterPiece = weakCharacterPiece;
        
        [_characterPiece rotate];
        GWAreaView *areaView = ((GWInfoBoxDeckCharacterView *)strong.infoBoxView).areaView;
        areaView.coordinates = strongCharacterPiece.summoningTileCoordinatesForAreaView;
    };
    [characterInfoBoxView.rotateButton addTarget:self withBlock:rotateBlock forControlEvents:UIControlEventTouchUpInside];
    
    if (_infoBoxView) [_infoBoxView removeFromSuperview];
    self.infoBoxView = characterInfoBoxView;
}

- (void)setRotateButtonHidden:(BOOL)hidden {
    if ([_infoBoxView isMemberOfClass:[GWInfoBoxDeckCharacterView class]]) {
        ((GWInfoBoxDeckCharacterView *)_infoBoxView).rotateButton.hidden = hidden;
    }
}

#pragma mark - GWInfoGridViewForCharacterPiece

- (void)setGridViewForCharacterPiece:(GWGridPieceCharacter *)characterPiece withClaimBlock:(UIButtonBlock)block withPlayer:(GWPlayer *)player {
    _characterPiece = characterPiece;
    GWInfoBoxGridCharacterView *characterInfoBoxView = [[GWInfoBoxGridCharacterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) withCharacterPiece:characterPiece];
    
    // If the player viewing doesnt own the character or the character has 0 actions left hide the claim button
    if (player.team != characterPiece.owner.team || characterPiece.character.actions <= 0) {
        characterInfoBoxView.claimButton.hidden = YES;
    } else {
        characterInfoBoxView.claimButton.hidden = NO;
        [characterInfoBoxView.claimButton addTarget:self withBlock:block forControlEvents:UIControlEventTouchUpInside];
    }


    if (_infoBoxView) [_infoBoxView removeFromSuperview];
    self.infoBoxView = characterInfoBoxView;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    if ([_infoBoxView isMemberOfClass:[GWInfoBoxGridCharacterView class]]) {
        ((GWInfoBoxGridCharacterView *)_infoBoxView).errorMessage.text = errorMessage;
    }
}

- (void)clearView {
    if (_infoBoxView) [_infoBoxView removeFromSuperview];
    self.infoBoxView = [[GWInfoBoxView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - setter/getter

- (void)setEndTurnBlock:(UIButtonBlock)block {
    _endTurnBlock = block;
    [_endTurnButton addTarget:self withBlock:_endTurnBlock forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInfoBoxView:(GWInfoBoxView *)infoBoxView {
    _infoBoxView = infoBoxView;
    [self.view insertSubview:_infoBoxView belowSubview:_endTurnButton];
}

@end
