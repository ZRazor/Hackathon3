//
//  GameScene.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    NSMutableArray *_players;
    MYSUInteger _currentPlayerIndex;
    MRPlayerSprite *myPlayer, *otherPlayer;
    NSTimer* playerActionTimer;
    float afterShotTime, afterMoveTime;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initializeGame];
    }
    self->afterShotTime = 0.3;
    self->afterMoveTime = 0.025;
    return self;
}

- (void)initializeGame {
    _players = [NSMutableArray arrayWithCapacity:2];
    
    [self initPlayer];
    _currentPlayerIndex = -1;
}


- (void)initPlayer
{
    myPlayer = [[MRPlayerSprite alloc] initWithPlayerType:kMyPlayer];
    otherPlayer = [[MRPlayerSprite alloc] initWithPlayerType:kOtherPlayer];
    
    myPlayer.position = CGPointMake(180, 50);
    otherPlayer.position = CGPointMake(180, 500);
    
    [self addChild:myPlayer];
    [self addChild:otherPlayer];
}

-(void)didMoveToView:(SKView *)view {
    _players = [NSMutableArray arrayWithCapacity:2];
}

- (MRPlayerActionType)playerActionWithPoint:(CGPoint)point
{
    const float k = 160, maxX = 320;
    
    float x = point.x;
    float y = point.y;
    
    if (x > 0 && y > 0 && x < k && y < k) {
        return kPlayerMoveLeft;
    } else if (x > k && x < maxX && y < k && y < k) {
        return kPlayerMoveRight;
    } else if (y > k) {
        return kPlayerFire;
    }
    return 0;
}

- (void)startPlayerActionWithType:(MRPlayerActionType)type
{
    switch (type) {
        case kPlayerFire:
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterShotTime target:self selector:@selector(playerFire) userInfo:nil repeats:YES];
            break;
        case kPlayerMoveRight:
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterMoveTime target:self selector:@selector(movePlayerRight) userInfo:nil repeats:YES];
            break;
        case kPlayerMoveLeft:
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterMoveTime  target:self selector:@selector(movePlayerLeft) userInfo:nil repeats:YES];
            break;
        default:
            break;
    }
}

- (void)stopPlayerActionWithType:(MRPlayerActionType)type
{
    [playerActionTimer  invalidate];
    playerActionTimer = nil;
}

- (void)movePlayerRight
{
    if (myPlayer.position.x > 317 - myPlayer.size.width) {
        return;
    }
    SKAction *moveAction = [SKAction moveTo:CGPointMake(myPlayer.position.x + 5, myPlayer.position.y) duration:afterMoveTime];
    [myPlayer runAction:moveAction];
    NSLog(@"move right");
}

- (void)movePlayerLeft
{
    if (myPlayer.position.x < 3 + myPlayer.size.width) {
        return;
    }
    SKAction *moveAction = [SKAction moveTo:CGPointMake(myPlayer.position.x - 5, myPlayer.position.y) duration:afterMoveTime];
    [myPlayer runAction:moveAction];
    NSLog(@"move left");
}

- (void)playerFire
{
    NSLog(@"player fire");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = touches.allObjects[0];
    
    [myPlayer setPosition:CGPointMake(myPlayer.position.x + 1, myPlayer.position.y)];
    
    [_networkingEngine sendMove:moveLeft];
    
    [self startPlayerActionWithType:[self playerActionWithPoint:[touch locationInNode:self]]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Для переключения оружия
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = touches.allObjects[0];
    [self stopPlayerActionWithType:[self playerActionWithPoint:[touch locationInNode:self]]];
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.paused && _currentPlayerIndex == -1) {
        return;
    }
    //check something
}

#pragma mark MultiplayerNetworkingProtocol

- (void)matchEnded {
    if (self.gameEndedBlock) {
        self.gameEndedBlock();
    }
}

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;
}

- (void)movePlayerAtIndex:(NSUInteger)index direction:(MoveDirection)direction {
    if (direction == moveLeft) {
        [otherPlayer setPosition:CGPointMake(otherPlayer.position.x + 1, otherPlayer.position.y)];
    }
    NSLog(@"Player %d moved to %d", index, direction);
}

- (void)gameOver:(BOOL)player1Won {
    BOOL didLocalPlayerWin = YES;
    if (player1Won) {
        didLocalPlayerWin = NO;
    }
    if (self.gameOverBlock) {
        self.gameOverBlock(didLocalPlayerWin);
    }
}

- (void)setPlayerAliases:(NSArray*)playerAliases {
    [playerAliases enumerateObjectsUsingBlock:^(NSString *playerAlias, NSUInteger idx, BOOL *stop) {
//        [_players[idx] setPlayerAliasText:playerAlias];
    }];
}

@end
