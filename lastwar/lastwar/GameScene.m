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
    NSUInteger _currentPlayerIndex;
    SKSpriteNode *_cat;
}

-(void)didMoveToView:(SKView *)view {
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    if (_currentPlayerIndex == -1) {
        return;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark MultiplayerNetworkingProtocol

- (void)matchEnded {
//    if (self.gameEndedBlock) {
//        self.gameEndedBlock();
//    }
}

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;
}

- (void)movePlayerAtIndex:(NSUInteger)index {

}

- (void)gameOver:(BOOL)player1Won {
//    BOOL didLocalPlayerWin = YES;
//    if (player1Won) {
//        didLocalPlayerWin = NO;
//    }
//    if (self.gameOverBlock) {
//        self.gameOverBlock(didLocalPlayerWin);
//    }
}

- (void)setPlayerAliases:(NSArray*)playerAliases {
//    [playerAliases enumerateObjectsUsingBlock:^(NSString *playerAlias, NSUInteger idx, BOOL *stop) {
//        [_players[idx] setPlayerAliasText:playerAlias];
//    }];
}

@end
