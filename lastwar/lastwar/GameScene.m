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
    
    float fastGuns, midGuns, slowGuns;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initializeGame];
    }
    self->afterShotTime = 0.3;
    self->afterMoveTime = 0.025;
    
    self->fastGuns = 1;
    self->midGuns = 2;
    self->slowGuns = 3;
    
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
            [self myPlayerFire];
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterShotTime target:self selector:@selector(myPlayerFire) userInfo:nil repeats:YES];
            break;
        case kPlayerMoveRight:
            [self moveMyPlayerRight];
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterMoveTime target:self selector:@selector(moveMyPlayerRight) userInfo:nil repeats:YES];
            break;
        case kPlayerMoveLeft:
            [self moveMyPlayerLeft];
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterMoveTime  target:self selector:@selector(moveMyPlayerLeft) userInfo:nil repeats:YES];
            break;
        default:
            break;
    }
}

- (void)moveMyPlayerLeft {
    [self movePlayerLeft:YES];
}

- (void)moveMyPlayerRight {
    [self movePlayerRight:YES];
}

- (void)stopPlayerActionWithType:(MRPlayerActionType)type
{
    [playerActionTimer  invalidate];
    playerActionTimer = nil;
}

- (void)movePlayerRight:(BOOL)isMyPlayer
{
    MRPlayerSprite *curPlayer;
    if (isMyPlayer) {
        curPlayer = myPlayer;
    } else {
        curPlayer = otherPlayer;
    }
    if (curPlayer.position.x > 317 - curPlayer.size.width) {
        return;
    }
    if (isMyPlayer) {
        [_networkingEngine sendMove:moveRight];
    }
    SKAction *moveAction = [SKAction moveTo:CGPointMake(curPlayer.position.x + 5, curPlayer.position.y) duration:afterMoveTime];
    [curPlayer runAction:moveAction];
    NSLog(@"move right");
}

- (void)movePlayerLeft:(BOOL)isMyPlayer
{
    MRPlayerSprite *curPlayer;
    if (isMyPlayer) {
        curPlayer = myPlayer;
    } else {
        curPlayer = otherPlayer;
    }
    if (curPlayer.position.x < 3 + curPlayer.size.width) {
        return;
    }
    if (isMyPlayer) {
        [_networkingEngine sendMove:moveLeft];
    }

    SKAction *moveAction = [SKAction moveTo:CGPointMake(curPlayer.position.x - 5, curPlayer.position.y) duration:afterMoveTime];
    [curPlayer runAction:moveAction];
    NSLog(@"move left");
}

- (void)myPlayerFire {
    [self playerFire:YES];
}

- (void)playerFire:(BOOL)isMyPlayer
{
    NSLog(@"player fire");
    if (isMyPlayer) {
        [_networkingEngine sendShot:[myPlayer position].x];
    }
    
    [self shotBulletWithStartCord:myPlayer.position];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = touches.allObjects[0];
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


#pragma mark - guns

- (void)shotBulletWithStartCord:(CGPoint)startPoint
{
    MRBulletNode* bullet = [[MRBulletNode alloc] initWithSpeed:1 AndDemage:50 AndStartPoint:startPoint];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(bullet.position.x, 580) duration:bullet.speed];
    [bullet runAction:moveAction];
    [self addChild:bullet];
}

#pragma mark - MultiplayerNetworkingProtocol

- (void)matchEnded {
    if (self.gameEndedBlock) {
        self.gameEndedBlock();
    }
}

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;
    self.gameStartBlock();
}

- (void)movePlayerAtIndex:(NSUInteger)index direction:(MoveDirection)direction {
    if (direction == moveLeft) {
        [self movePlayerLeft:NO];
    } else if (direction == moveRight) {
        [self movePlayerRight:NO];
    }

    NSLog(@"Player %d moved to %d", index, direction);
}

- (void)shotPlayerAtIndex:(NSUInteger)index playerPosition:(PlayerPosition)position {

    NSLog(@"Player %d shot at %f", index, position);
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
