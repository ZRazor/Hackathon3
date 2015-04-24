//
//  GameScene.h
//  lastwar
//

//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MRMultiplayerNetworking.h"

@interface GameScene : SKScene <MultiplayerNetworkingProtocol>
@property (nonatomic, copy) void (^gameOverBlock)(BOOL didWin);
@property (nonatomic, copy) void (^gameEndedBlock)();
@property (nonatomic, strong) MRMultiplayerNetworking *networkingEngine;
@end
