//
//  MultiplayerNetworking.h
//  CatRaceStarter
//
//  Created by Kauserali on 06/01/14.
//  Copyright (c) 2014 Raywenderlich. All rights reserved.
//

#import "GameKitHelper.h"

@protocol MultiplayerNetworkingProtocol <NSObject>
/*
 Begin game
 returns the index of the player in _orderPlayers
 index 0 means player is the server
 */
- (void)beginGameWithPlayerIndex:(NSUInteger)index;
- (void)gameOver:(BOOL)serverWon; // Game ended
- (void)movePlayerAtIndex:(NSUInteger)index;
@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;

/*
 Should be called by server player (index = 0). Will send
 game over message to all other players.
 */
- (id)initWithPlayerData:(NSData *)playerData;
- (void)sendGameEnd:(BOOL)serverWon;
- (void)sendMove;

@end
