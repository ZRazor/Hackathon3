//
//  GameScene.h
//  lastwar
//

//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MRMultiplayerNetworking.h"
#import "MRPlayerSprite.h"
#import "MRBulletNode.h"

typedef enum {
    kPlayerMoveRight = 1,
    kPlayerMoveLeft = 2,
    kPlayerFire = 3,
} MRPlayerActionType;


@interface GameScene : SKScene <MultiplayerNetworkingProtocol, SKPhysicsContactDelegate>
@property (nonatomic, copy) void (^gameOverBlock)(MRMatchEndType endType);
@property (nonatomic, copy) void (^gameEndedBlock)();
@property (nonatomic, copy) void (^gameStartBlock)();
@property (nonatomic, strong) MRMultiplayerNetworking *networkingEngine;

@property (nonatomic, strong) SKSpriteNode *rightButtonBg, *leftButtonBg, *fireButtonBg;

@end
