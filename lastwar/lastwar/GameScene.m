//
//  GameScene.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "GameScene.h"
#import "masks.h"
#import "MRBlockNode.h"

@implementation GameScene {
    NSMutableArray *_players;
    MYSUInteger _currentPlayerIndex;
    MRPlayerSprite *myPlayer, *otherPlayer;
    NSTimer *playerActionTimer;
    NSTimer *playerMoveTimer;
    float afterShotTime, afterMoveTime;
    BOOL matchEnded;
    
    UITouch* touch;
    
    float fastGuns, midGuns, slowGuns;
    
    CGPoint startControllPoint;
    
    MRPlayerActionType startAtActionType;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initializeGame];
    }
    matchEnded = NO;
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
    [self drawInterface];
    _currentPlayerIndex = -1;

    self.physicsWorld.contactDelegate = self;

    SKSpriteNode* bgNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"bg_sand"]];
    bgNode.zPosition = -100;
    bgNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgNode];

    //BLOCKS
    MRBlockNode *block = [[MRBlockNode alloc] initWithPosition:CGPointMake(100, 300)];
    [self addChild:block];
}

#pragma mark - Interface

- (void)drawInterface
{
    SKSpriteNode* bgBottonMenu = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"menu_bottom"]];
    bgBottonMenu.size = CGSizeMake(320, 72);
    bgBottonMenu.position = CGPointMake(CGRectGetMidX(self.frame), 36);

    [self addChild:bgBottonMenu];
    
    _leftButtonBg = [[SKSpriteNode alloc] init];
    _leftButtonBg.position = CGPointMake(50, 36);
    _leftButtonBg.size = CGSizeMake(50, 50);
    
    _fireButtonBg = [[SKSpriteNode alloc] init];
    _fireButtonBg.position = CGPointMake(160, 36);
    _fireButtonBg.size = CGSizeMake(56, 50);
    
    _rightButtonBg = [[SKSpriteNode alloc] init];
    _rightButtonBg.position = CGPointMake(270, 36);
    _rightButtonBg.size = CGSizeMake(50, 50);
    
    [self setDefaultButtonTexture];
    
    [self addChild:_leftButtonBg];
    [self addChild:_fireButtonBg];
    [self addChild:_rightButtonBg];
    
}

- (void)setDefaultButtonTexture
{
    [self setDefaultLeftTexture];
    [self setDefaultFireTexture];
    [self setDefaultRightTexture];
}

- (void)setDefaultLeftTexture
{
    _leftButtonBg.texture = [SKTexture textureWithImageNamed:@"btn_left_0"];
}

- (void)setDefaultFireTexture
{
    _fireButtonBg.texture = [SKTexture textureWithImageNamed:@"btn_fire_0"];
}

- (void)setDefaultRightTexture
{
    _rightButtonBg.texture = [SKTexture textureWithImageNamed:@"btn_right_0"];
}

- (void)setActiveLeftTexture
{
    _leftButtonBg.texture = [SKTexture textureWithImageNamed:@"btn_left_1"];
}

- (void)setActiveFireTexture
{
    _fireButtonBg.texture = [SKTexture textureWithImageNamed:@"btn_fire_1"];
}

- (void)setActiveRightTexture
{
    _rightButtonBg.texture = [SKTexture textureWithImageNamed:@"btn_right_1"];
}


#pragma mark - Physics

- (void)didBeginContact:(SKPhysicsContact *)contact {
    MRDamagedObject *damObject;
    MRBulletNode *bullet;
    if ([[contact bodyA].node isKindOfClass:[MRDamagedObject class]]) {
        damObject = (MRDamagedObject *)[contact bodyA].node;
        bullet = (MRBulletNode *)[contact bodyB].node;
    } else {
        damObject = (MRDamagedObject *)[contact bodyB].node;
        bullet = (MRBulletNode *)[contact bodyA].node;
    }
    damObject.hp -= bullet.damage;
    if ([damObject isKindOfClass:[MRBlockNode class]] && damObject.hp <= 0) {
        [damObject removeFromParent];
    }
    NSLog(@"Damage -5!");
    [bullet removeFromParent];
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
    myPlayer = [self createPlayerAtCoord:CGPointMake(160, 105) andType:kMyPlayer];
    otherPlayer = [self createPlayerAtCoord:CGPointMake(160, 516) andType:kOtherPlayer];

    [self addChild:myPlayer];
    [self addChild:otherPlayer];
}

-(void)didMoveToView:(SKView *)view {
    _players = [NSMutableArray arrayWithCapacity:2];
}

- (MRPlayerActionType)playerActionWithPoint:(CGPoint)point
{
    const float mK = 100, fK = 220, maxY = 160;
    
    float x = point.x;
    float y = point.y;
    
    if (x > 0 && x < mK && y < maxY) {
        return kPlayerMoveLeft;
    } else if (x > mK && x < fK &&  y < maxY){
        return kPlayerFire;
        
    } else if (x > fK && y < maxY) {
        return kPlayerMoveRight;
    }
    return 0;
}

- (void)startPlayerActionWithType:(MRPlayerActionType)type
{
    switch (type) {
        case kPlayerFire:
            [self myPlayerFire];
            [self setActiveFireTexture];
            playerActionTimer = [NSTimer scheduledTimerWithTimeInterval:afterShotTime target:self selector:@selector(myPlayerFire) userInfo:nil repeats:YES];
            break;
        case kPlayerMoveRight:
            [self moveMyPlayerRight];
            [self setActiveRightTexture];
            playerMoveTimer = [NSTimer scheduledTimerWithTimeInterval:afterMoveTime target:self selector:@selector(moveMyPlayerRight) userInfo:nil repeats:YES];
            break;
        case kPlayerMoveLeft:
            [self moveMyPlayerLeft];
            [self setActiveLeftTexture];
            playerMoveTimer = [NSTimer scheduledTimerWithTimeInterval:afterMoveTime  target:self selector:@selector(moveMyPlayerLeft) userInfo:nil repeats:YES];
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
    if (position > self.size.width - player.size.width / 2) {
        position = self.size.width - player.size.width / 2;
    }
    if (position < 0 + player.size.width / 2) {
        position = player.size.width / 2;
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
    if (playerActionTimer) {
        [playerActionTimer  invalidate];
    }
    playerActionTimer = nil;
    
    if (playerMoveTimer) {
        [playerMoveTimer invalidate];
    }
    playerMoveTimer = nil;
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
        startPoint = CGPointMake(position + 10, myPlayer.position.y + 30);
        endPoint = CGPointMake(position + 10, 600);
    } else {
        startPoint = CGPointMake(position + 10, otherPlayer.position.y - 30);
        endPoint = CGPointMake(position + 10, -20);
    }
    
    [self shotBulletWithStartCord:startPoint AndEndPoint:endPoint];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    touch = touches.allObjects[0];
    MRPlayerActionType actionType = [self playerActionWithPoint:[touch locationInNode:self]];
    startAtActionType = actionType;
    [self startPlayerActionWithType:actionType];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    touch = touches.allObjects[0];
    float x = [touch locationInNode:self].x;
    
    if (startAtActionType != kPlayerFire) {
        if (startAtActionType == kPlayerMoveLeft && x > 220) {
            [playerMoveTimer invalidate];
            playerMoveTimer = nil;
            [self setDefaultLeftTexture];
        } else if (startAtActionType == kPlayerMoveRight && x < 100) {
            [playerMoveTimer invalidate];
            playerMoveTimer = nil;
            [self setDefaultRightTexture];
        }
        return;
    }
    
    if (x < 100) {
        [playerMoveTimer invalidate];
        playerMoveTimer = nil;
        [self moveWithFireWithType:kPlayerMoveLeft];
    } else if (x > 220) {
        [playerMoveTimer invalidate];
        playerMoveTimer = nil;
        [self moveWithFireWithType:kPlayerMoveRight];
    } else if (x > 100 && x < 220) {
        [self setDefaultLeftTexture];
        [self setDefaultRightTexture];
        [playerMoveTimer invalidate];
        playerMoveTimer = nil;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    startAtActionType = 0;
    touch = touches.allObjects[0];
    [self stopPlayerActionWithType:[self playerActionWithPoint:[touch locationInNode:self]]];
    [self setDefaultButtonTexture];
    startControllPoint = CGPointMake(0, 0);
}

- (void)moveWithFireWithType:(MRPlayerActionType)type
{
    if (playerActionTimer) {
        if (!playerMoveTimer) {
            [self startPlayerActionWithType:type];
        }
    }
}

- (void)endGameWithStatus:(MRMatchEndType)endType {
    if (matchEnded) { return; }
    self.paused = YES;
    matchEnded = YES;
    _currentPlayerIndex = -1;

    [_networkingEngine sendGameEnd:(endType == kWinEnd)];
    if (self.gameOverBlock) {
        self.gameOverBlock(endType);
    }
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.paused && _currentPlayerIndex == -1) {
        return;
    }

    if (myPlayer.hp <= 0) {
        [self endGameWithStatus:kLoseEnd];
    } else if (otherPlayer.hp <= 0) {
        [self endGameWithStatus:kWinEnd];
    }


    //check something
}


#pragma mark - guns

- (void)shotBulletWithStartCord:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint
{
    MRBulletNode* bullet = [[MRBulletNode alloc] initWithSpeed:1 AndDamage:10 AndStartPoint:startPoint];
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
    NSLog(@"Player %d moved to %f", index, position);
    [self movePlayerToPos:position player:otherPlayer];
}

- (void)shotPlayerAtIndex:(NSUInteger)index playerPosition:(PlayerPosition)position {
    NSLog(@"Player %d shot at %f", index, position);
    if (otherPlayer.position.x != position) {
        [self movePlayerToPos:position player:otherPlayer];
    }
    [self playerFire:otherPlayer position:position];
}


- (void)gameOver:(MRMatchEndType) endType {
    if (matchEnded) { return; }
    self.paused = YES;
    matchEnded = YES;
    _currentPlayerIndex = -1;
    if (self.gameOverBlock) {
        self.gameOverBlock(endType);
    }
}

- (void)setPlayerAliases:(NSArray*)playerAliases {
    [playerAliases enumerateObjectsUsingBlock:^(NSString *playerAlias, NSUInteger idx, BOOL *stop) {
//        [_players[idx] setPlayerAliasText:playerAlias];
    }];
}

@end
