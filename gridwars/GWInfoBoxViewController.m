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
#import "GWInfoBoxStoreCharacterView.h"
#import "GWGridPieceCharacter.h"
#import "GWAreaView.h"
#import "GWPlayer.h"
#import "GWCharacter.h"
#import "GWButton.h"

@interface GWInfoBoxViewController ()

@end

@implementation GWInfoBoxViewController {
    float _sidePadding;
    GWGridPieceCharacter *_characterPiece;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (!self) return nil;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
    
    _button = [[GWButton alloc] initWithFrame:CGRectMake(210.0f - 90.0f, 50.0f, 70.0f, 30.0f)];
    [_button setTitle:@"Central" forState:UIControlStateNormal];
    _button.hidden = YES;
    [self.view addSubview:_button];
    
    self.infoBoxView = [[GWInfoBoxView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    
    return self;
}

#pragma mark - GWInfoDeckViewForStore

- (void)setViewForStoreWithCharacter:(GWCharacter *)character {
    GWInfoBoxStoreCharacterView *characterInfoBoxView = [[GWInfoBoxStoreCharacterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) withCharacter:character];
    if (_infoBoxView) [_infoBoxView removeFromSuperview];
    self.infoBoxView = characterInfoBoxView;
}


#pragma mark - GWInfoDeckViewForCharacterPiece

- (void)setViewForDeckWithCharacterPiece:(GWGridPieceCharacter *)characterPiece {
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

- (void)setViewForGridWithCharacterPiece:(GWGridPieceCharacter *)characterPiece withClaimBlock:(UIButtonBlock)block withPlayer:(GWPlayer *)player {
    _characterPiece = characterPiece;
    GWInfoBoxGridCharacterView *characterInfoBoxView = [[GWInfoBoxGridCharacterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) withCharacterPiece:characterPiece];
    
    // If the player viewing doesnt own the character or the character has 0 actions left hide the claim button
    if (player.team != characterPiece.owner.team || characterPiece.character.actions <= 0) {
        characterInfoBoxView.claimButton.hidden = YES;
    } else {
        characterInfoBoxView.claimButton.hidden = NO;
        [characterInfoBoxView.claimButton addTarget:self withBlock:block forControlEvents:UIControlEventTouchUpInside];
    }

    self.infoBoxView = characterInfoBoxView;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    if ([_infoBoxView isMemberOfClass:[GWInfoBoxGridCharacterView class]]) {
        ((GWInfoBoxGridCharacterView *)_infoBoxView).errorMessage.text = errorMessage;
    }
}

- (void)clearView {
    self.infoBoxView = [[GWInfoBoxView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - setter/getter

- (void)setInfoBoxView:(GWInfoBoxView *)infoBoxView {
    
    [_infoBoxView removeFromSuperview];
    
    _infoBoxView = infoBoxView;
    _infoBoxView.frame = CGRectOffset(_infoBoxView.frame, 0.0f, 30.0f);
    _infoBoxView.alpha = 0.0f;
    [self.view insertSubview:_infoBoxView belowSubview:_button];
    
    [UIView animateWithDuration:0.7f
                     animations:^{
                         _infoBoxView.frame = CGRectOffset(_infoBoxView.frame, 0.0f, -30.0f);
                         _infoBoxView.alpha = 1.0f;
                     }];
}

@end
