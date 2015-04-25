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

    self.physicsBody =
            [SKPhysicsBody bodyWithTexture:self.texture size:self.texture.size];
    self.physicsBody.categoryBitMask = categoryPlayers;
    self.physicsBody.contactTestBitMask = categoryBullets;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.affectedByGravity = NO;

    if (!self) {
        return NULL;
    }
    return self;
}

@end;
