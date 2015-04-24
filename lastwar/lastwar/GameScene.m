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
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initializeGame];
    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    if (_currentPlayerIndex == -1) {
        return;
    }
    
    [myPlayer setPosition:CGPointMake(myPlayer.position.x + 1, myPlayer.position.y)];
    
    [_networkingEngine sendMove:moveLeft];
}

-(void)update:(CFTimeInterval)currentTime {
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
