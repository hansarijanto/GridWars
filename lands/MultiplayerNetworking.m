//
//  MultiplayerNetworking.m
//  CatRaceStarter
//
//  Created by Kauserali on 06/01/14.
//  Copyright (c) 2014 Raywenderlich. All rights reserved.
//

#define playerIdKey @"PlayerId"
#define playerDataKey @"PlayerData"
#define randomNumberKey @"randomNumber"

#import "MultiplayerNetworking.h"
#import "GWPlayer.h"
#import "GWCharacter.h"

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForHandshake,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
};

typedef NS_ENUM(NSUInteger, MessageType) {
    kMessageTypeHandshake = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeGameOver
};

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageHandshake;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
} MessageMove;

typedef struct {
    Message message;
    BOOL serverWon;
} MessageGameOver;


@implementation MultiplayerNetworking {
    uint32_t _ourRandomNumber;
    NSData *_ourPlayerData;
    GameState _gameState;
    BOOL _isPlayerServer, _receivedAllHandshakes;
    
    NSMutableArray *_orderOfPlayers;
};

- (id)initWithPlayerData:(NSData *)playerData
{
    if (self = [super init]) {
        _ourRandomNumber = arc4random();
        _ourPlayerData = playerData;
        _gameState = kGameStateWaitingForMatch;
        _orderOfPlayers = [NSMutableArray array];
        [_orderOfPlayers addObject:@{playerIdKey : [GKLocalPlayer localPlayer].playerID,
                                     randomNumberKey : @(_ourRandomNumber)}];
    }
    return self;
}

/*
 When all connected players have received random numbers from every other player
 this method is called. If this player is the server then send game begin message
 to every other player.
 */
- (void)tryStartGame {
    if (_isPlayerServer && _gameState == kGameStateWaitingForStart) {
        _gameState = kGameStateActive;
        [self sendGameBegin];
        
        // first player
        [self.delegate beginGameWithPlayerIndex:0];
    }
}

#pragma mark - Send Messages

/*
 These are custom messages that represent an action in the game. To create a message
 simply create a message struct at the top of the file. Then create a method to send
 the newly created data to all of the other players. Then in didReceiveData handle
 receiving the new message by creating a new method in the protocol, such that
 the game controller can handle when a specific message is received.
 */

- (void)sendMove {
    MessageMove messageMove;
    messageMove.message.messageType = kMessageTypeMove;
    NSData *data = [NSData dataWithBytes:&messageMove
                                  length:sizeof(MessageMove)];
    [self sendData:data];
}

/*
 Called when a server detects that all player's have connected
 and player order has been determined.
 */
- (void)sendGameBegin {
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
}

- (void)sendGameEnd:(BOOL)serverWon {
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.serverWon = serverWon;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
}

#pragma mark - Player Order / Server

/*
 When all users are connected they all send random numbers to each other.
 Using these random number players are ordered in _orderPlayers.
 The first player in that order is named the server of the match,
 a server dictates when a game starts and when a game ends.
 */

- (void)sendHandshake
{
    MessageHandshake message;
    message.message.messageType = kMessageTypeHandshake;
    message.randomNumber = _ourRandomNumber;
    
    // send handshake message
    NSMutableData *data = [NSMutableData dataWithBytes:&message length:sizeof(MessageHandshake)];
    [self sendData:data];
}

-(void)processReceivedHandshake:(NSDictionary *)handshakeDict {
    
    if([_orderOfPlayers containsObject:handshakeDict]) {
        [_orderOfPlayers removeObjectAtIndex:
         [_orderOfPlayers indexOfObject:handshakeDict]];
    }
    [_orderOfPlayers addObject:handshakeDict];
    
    NSSortDescriptor *sortByRandomNumber = [NSSortDescriptor sortDescriptorWithKey:randomNumberKey
                                                                         ascending:NO];
    NSArray *sortDescriptors = @[sortByRandomNumber];
    [_orderOfPlayers sortUsingDescriptors:sortDescriptors];
    
    if ([self allHandshakesReceived]) {
        _receivedAllHandshakes = YES;
    }
}

- (BOOL)allHandshakesReceived
{
    NSMutableArray *receivedHandshakes = [NSMutableArray array];
    
    for (NSDictionary *dict in _orderOfPlayers) {
        [receivedHandshakes addObject:dict[randomNumberKey]];
    }
    
    NSArray *arrayOfUniqueHandshakes = [[NSSet setWithArray:receivedHandshakes] allObjects];
    
    if (arrayOfUniqueHandshakes.count ==
        [GameKitHelper sharedGameKitHelper].match.playerIDs.count + 1) {
        return YES;
    }
    return NO;
}

- (BOOL)isLocalPlayerServer
{
    NSDictionary *dictionary = _orderOfPlayers[0];
    if ([dictionary[playerIdKey] isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        NSLog(@"I'm server");
        return YES;
    }
    return NO;
}

- (NSUInteger)indexForLocalPlayer
{
    NSString *playerId = [GKLocalPlayer localPlayer].playerID;
    
    return [self indexForPlayerWithId:playerId];
}

- (NSUInteger)indexForPlayerWithId:(NSString*)playerId
{
    __block NSUInteger index = -1;
    [_orderOfPlayers enumerateObjectsUsingBlock:^(NSDictionary
                                                  *obj, NSUInteger idx, BOOL *stop){
        NSString *pId = obj[playerIdKey];
        if ([pId isEqualToString:playerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

#pragma mark - GameKitHelper Delegate Methods

// Called when all playes are connected
- (void)matchStarted {
    NSLog(@"All players connected");
    if (_receivedAllHandshakes) {
        _gameState = kGameStateWaitingForStart;
    } else {
        _gameState = kGameStateWaitingForHandshake;
    }
    [self sendHandshake];
    [self tryStartGame];
}

/*
 Sending data to all other active players
 */
- (void)sendData:(NSData*)data
{
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    BOOL success = [gameKitHelper.match
                    sendDataToAllPlayers:data
                    withDataMode:GKMatchSendDataReliable
                    error:&error];
    
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }
}

// Called when data is sent from another player
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID {
    Message *message = (Message*)[data bytes];
    if (message->messageType == kMessageTypeHandshake) {
        MessageHandshake *messageHandshake = (MessageHandshake*)[data bytes];
        
        NSLog(@"Received random number:%d", messageHandshake->randomNumber);
        
        BOOL tie = NO;
        if (messageHandshake->randomNumber == _ourRandomNumber) {
            NSLog(@"Tie");
            tie = YES;
            _ourRandomNumber = arc4random();
            [self sendHandshake];
        } else {
            NSDictionary *handshakeDict = @{
                                            playerIdKey : playerID,
                                            randomNumberKey : @(messageHandshake->randomNumber),
                                            };
            [self processReceivedHandshake:handshakeDict];
        }
        
        if (_receivedAllHandshakes) {
            _isPlayerServer = [self isLocalPlayerServer];
        }
        
        if (!tie && _receivedAllHandshakes) {
            if (_gameState == kGameStateWaitingForHandshake) {
                _gameState = kGameStateWaitingForStart;
            }
            [self tryStartGame];
        }
    }
    else if (message->messageType == kMessageTypeGameBegin) {
        NSLog(@"Begin game message received");
        [self.delegate beginGameWithPlayerIndex:[self indexForLocalPlayer]];
        _gameState = kGameStateActive;
    }
    else if (message->messageType == kMessageTypeMove) {
        NSLog(@"Move message received");
        MessageMove *messageMove = (MessageMove*)[data bytes];
        [self.delegate movePlayerAtIndex:[self indexForPlayerWithId:playerID]];
    } else if(message->messageType == kMessageTypeGameOver) {
        NSLog(@"Game over message received");
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        [self.delegate gameOver:messageGameOver->serverWon];
    }
}

// Called when a match has ended
- (void)matchEnded {
    NSLog(@"Match has ended");
}
@end
