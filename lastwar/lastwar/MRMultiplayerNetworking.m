#import "MRMultiplayerNetworking.h"

#define playerIdKey @"PlayerId"
#define randomNumberKey @"randomNumber"

typedef NS_ENUM(MYSUInteger, GameState) {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
};

typedef NS_ENUM(MYSUInteger, MessageType) {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeShot,
    kMessageTypeGameOver
};

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    PlayerPosition position;
} MessageMove;


typedef struct {
    Message message;
    PlayerPosition playerPosition;
} MessageShot;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

@implementation MRMultiplayerNetworking {
    uint32_t _ourRandomNumber;
    GameState _gameState;
    BOOL _isPlayer1, _receivedAllRandomNumbers;
    
    NSMutableArray *_orderOfPlayers;
}

- (id)init
{
    if (self = [super init]) {
        _ourRandomNumber = arc4random();
        _gameState = kGameStateWaitingForMatch;
        _orderOfPlayers = [NSMutableArray array];
        [_orderOfPlayers addObject:@{playerIdKey : [GKLocalPlayer localPlayer].playerID,
                                     randomNumberKey : @(_ourRandomNumber)}];
    }
    return self;
}

- (void)sendData:(NSData*)data
{
    NSError *error;
    MRGameKitHelper *gameKitHelper = [MRGameKitHelper sharedGameKitHelper];
    
    BOOL success = [gameKitHelper.match
                    sendDataToAllPlayers:data
                    withDataMode:GKMatchSendDataReliable
                    error:&error];
    
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self.delegate gameOver:kErrorEnd];
    }
}

- (void)sendMove:(PlayerPosition)position {
    MessageMove messageMove;
    messageMove.message.messageType = kMessageTypeMove;
    messageMove.position = position;
    NSData *data = [NSData dataWithBytes:&messageMove
                                  length:sizeof(MessageMove)];
    [self sendData:data];
}

- (void)sendShot:(PlayerPosition)position {
    MessageShot messageShot;
    messageShot.message.messageType = kMessageTypeShot;
    messageShot.playerPosition = position;
    NSData *data = [NSData dataWithBytes:&messageShot
                                  length:sizeof(messageShot)];
    [self sendData:data];
}

- (void)sendRandomNumber
{
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = _ourRandomNumber;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {
    
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
    
}

- (void)sendGameEnd:(BOOL)player1Won {
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
}

- (MYSUInteger)indexForLocalPlayer
{
    NSString *playerId = [GKLocalPlayer localPlayer].playerID;
    
    return [self indexForPlayerWithId:playerId];
}

- (MYSUInteger)indexForPlayerWithId:(NSString*)playerId
{
    __block MYSUInteger index = -1;
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

- (void)tryStartGame
{
    if (_isPlayer1 && _gameState == kGameStateWaitingForStart) {
        _gameState = kGameStateActive;
        [self sendGameBegin];
        
        //first player
        [self.delegate setCurrentPlayerIndex:0];
        [self processPlayerAliases];
    }
}

- (BOOL)allRandomNumbersAreReceived
{
    NSMutableArray *receivedRandomNumbers =
    [NSMutableArray array];
    
    for (NSDictionary *dict in _orderOfPlayers) {
        [receivedRandomNumbers addObject:dict[randomNumberKey]];
    }
    
    NSArray *arrayOfUniqueRandomNumbers = [[NSSet setWithArray:receivedRandomNumbers] allObjects];

    return arrayOfUniqueRandomNumbers.count ==
    [MRGameKitHelper sharedGameKitHelper].match.playerIDs.count + 1;
}

-(void)processReceivedRandomNumber:(NSDictionary*)randomNumberDetails {
    //1
    if([_orderOfPlayers containsObject:randomNumberDetails]) {
        [_orderOfPlayers removeObjectAtIndex:
         [_orderOfPlayers indexOfObject:randomNumberDetails]];
    }
    //2
    [_orderOfPlayers addObject:randomNumberDetails];
    
    //3
    NSSortDescriptor *sortByRandomNumber =
    [NSSortDescriptor sortDescriptorWithKey:randomNumberKey
                                  ascending:NO];
    NSArray *sortDescriptors = @[sortByRandomNumber];
    [_orderOfPlayers sortUsingDescriptors:sortDescriptors];
    
    //4
    if ([self allRandomNumbersAreReceived]) {
        _receivedAllRandomNumbers = YES;
    }
}

- (void)processPlayerAliases {
    if ([self allRandomNumbersAreReceived]) {
        NSMutableArray *playerAliases = [NSMutableArray arrayWithCapacity:_orderOfPlayers.count];
        for (NSDictionary *playerDetails in _orderOfPlayers) {
            NSString *playerId = playerDetails[playerIdKey];
            [playerAliases addObject:((GKPlayer*)[MRGameKitHelper sharedGameKitHelper].playersDict[playerId]).alias];
        }
        if (playerAliases.count > 0) {
            [self.delegate setPlayerAliases:playerAliases];
        }
    }
}

- (BOOL)isLocalPlayerPlayer1
{
    NSDictionary *dictionary = _orderOfPlayers[0];
    if ([dictionary[playerIdKey]
         isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        NSLog(@"I'm player 1");
        return YES;
    }
    return NO;
}

#pragma mark GameKitHelper delegate methods

- (void)matchStarted {
    NSLog(@"Match has started successfully");
    if (_receivedAllRandomNumbers) {
        _gameState = kGameStateWaitingForStart;
    } else {
        _gameState = kGameStateWaitingForRandomNumber;
    }
    [self sendRandomNumber];
    [self tryStartGame];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID {
    //1
    Message *message = (Message*)[data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        MessageRandomNumber *messageRandomNumber = (MessageRandomNumber*)[data bytes];
        
        NSLog(@"Received random number:%d", messageRandomNumber->randomNumber);
        
        BOOL tie = NO;
        if (messageRandomNumber->randomNumber == _ourRandomNumber) {
            //2
            NSLog(@"Tie");
            tie = YES;
            _ourRandomNumber = arc4random();
            [self sendRandomNumber];
        } else {
            //3
            NSDictionary *dictionary = @{playerIdKey : playerID,
                                         randomNumberKey : @(messageRandomNumber->randomNumber)};
            [self processReceivedRandomNumber:dictionary];
        }
        
        //4
        if (_receivedAllRandomNumbers) {
            _isPlayer1 = [self isLocalPlayerPlayer1];
        }
        
        if (!tie && _receivedAllRandomNumbers) {
            //5
            if (_gameState == kGameStateWaitingForRandomNumber) {
                _gameState = kGameStateWaitingForStart;
            }
            [self tryStartGame];
        }
    } else if (message->messageType == kMessageTypeGameBegin) {
        NSLog(@"Begin game message received");
        _gameState = kGameStateActive;
        [self.delegate setCurrentPlayerIndex:[self indexForLocalPlayer]];
        [self processPlayerAliases];
    } else if (message->messageType == kMessageTypeMove) {
        NSLog(@"Move message received");
        MessageMove *messageMove = (MessageMove*)[data bytes];
        [self.delegate movePlayerAtIndex:[self indexForPlayerWithId:playerID] position:messageMove->position];
    } else if (message->messageType == kMessageTypeShot) {
        NSLog(@"Shot message received");
        MessageShot *messageShot = (MessageShot*)[data bytes];
        [self.delegate shotPlayerAtIndex:[self indexForPlayerWithId:playerID] playerPosition:messageShot->playerPosition];
    } else if(message->messageType == kMessageTypeGameOver) {
        NSLog(@"Game over message received");
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        MRMatchEndType endType = kWinEnd;
        if (messageGameOver->player1Won) {
            endType = kLoseEnd;
        }
        [self.delegate gameOver:endType];
    }
}
@end
