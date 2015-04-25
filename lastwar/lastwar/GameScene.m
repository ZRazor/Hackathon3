//
//  GameScene.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "GameScene.h"
#import "masks.h"

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

    [self initPlayers];
    _currentPlayerIndex = -1;

    self.physicsWorld.contactDelegate = self;

    SKSpriteNode* bgNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"bg_sand"]];
    bgNode.zPosition = -100;
    bgNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgNode];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    [[contact bodyA].node setHidden:YES];
    [[contact bodyB].node setHidden:YES];
    NSLog(@"Contact begin");
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact end");
}

-(MRPlayerSprite *)createPlayerAtCoord:(CGPoint)point andType:(MRPlayerType)type {
    MRPlayerSprite *player = [[MRPlayerSprite alloc] initWithPlayerType:type];
    player.position = point;

    return player;
}

- (void)initPlayers
{
    myPlayer = [self createPlayerAtCoord:CGPointMake(180, 30) andType:kMyPlayer];
    otherPlayer = [self createPlayerAtCoord:CGPointMake(180, 548) andType:kOtherPlayer];

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
    PlayerPosition newPos = myPlayer.position.x - 5;
    [_networkingEngine sendMove:newPos];
    [self movePlayerToPos:newPos player:myPlayer];
}

- (void)movePlayerToPos:(PlayerPosition)position player:(MRPlayerSprite *)player {
    if (player.position.x > 317 - player.size.width) {
        return;
    }
    SKAction *moveAction = [SKAction moveTo:CGPointMake(position, player.position.y) duration:afterMoveTime];
    [player runAction:moveAction];
}

- (void)moveMyPlayerRight {
    PlayerPosition newPos = myPlayer.position.x + 5;
    [_networkingEngine sendMove:newPos];
    [self movePlayerToPos:newPos player:myPlayer];
}

- (void)stopPlayerActionWithType:(MRPlayerActionType)type
{
    //?????
    [playerActionTimer  invalidate];
    playerActionTimer = nil;
}

- (void)myPlayerFire {
    [_networkingEngine sendShot:[myPlayer position].x];
    [self playerFire:myPlayer position:[myPlayer position].x];
}

- (void)playerFire:(MRPlayerSprite *)player position:(PlayerPosition)position
{
    CGPoint startPoint;
    CGPoint endPoint;
    
    NSLog(@"player fire");
    
    if (player == myPlayer) {
        startPoint = CGPointMake(position + 10, myPlayer.position.y + 19);
        endPoint = CGPointMake(position + 10, 580);
    } else {
        startPoint = CGPointMake(position + 10, otherPlayer.position.y - 19);
        endPoint = CGPointMake(position + 10, -3);
    }
    
    [self shotBulletWithStartCord:startPoint AndEndPoint:endPoint];
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

- (void)shotBulletWithStartCord:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint
{
    MRBulletNode* bullet = [[MRBulletNode alloc] initWithSpeed:1 AndDemage:50 AndStartPoint:startPoint];
    SKAction *moveAction = [SKAction moveTo:endPoint duration:bullet.speed];
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

- (void)movePlayerAtIndex:(NSUInteger)index position:(PlayerPosition)position {
    [self movePlayerToPos:position player:otherPlayer];
    NSLog(@"Player %d moved to %f", index, position);
}

- (void)shotPlayerAtIndex:(NSUInteger)index playerPosition:(PlayerPosition)position {
    if (otherPlayer.position.x != position) {
        [self movePlayerToPos:position player:otherPlayer];
    }
    [self playerFire:otherPlayer position:position];
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
