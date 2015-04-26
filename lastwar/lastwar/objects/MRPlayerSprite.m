//
//  RMPlayerSprite.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRPlayerSprite.h"
#import "masks.h"

@implementation MRPlayerSprite

- (id)initWithPlayerType:(MRPlayerType)type
{
    if (type == kMyPlayer) {
        self = [super initWithTexture:[SKTexture textureWithImageNamed:@"robot"] color:nil size:CGSizeMake(32, 32)];
    } else if (type == kOtherPlayer) {
        self = [super initWithTexture:[SKTexture textureWithImageNamed:@"robot2"] color:nil size:CGSizeMake(32, 32)];
    }

    self.hp = 100;
    self.bulletsCount = 50;

    self.physicsBody =
            [SKPhysicsBody bodyWithTexture:self.texture size:self.texture.size];
    self.physicsBody.categoryBitMask = categoryPlayers;
    self.physicsBody.contactTestBitMask = categoryBullets;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.usesPreciseCollisionDetection = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;

    if (!self) {
        return NULL;
    }
    return self;
}

@end;
