//
//  MRBulletNode.m
//  lastwar
//
//  Created by Зинов Михаил  on 25.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRBulletNode.h"
#import "masks.h"

@implementation MRBulletNode

-(instancetype)initWithSpeed:(NSInteger)speed AndDamage:(NSInteger)damage AndStartPoint:(CGPoint)startPoint;
{
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"bullet_1"] color:nil size:CGSizeMake(20, 20)];
    
    self.damage = damage;
    self.speed = speed;
    self.position = startPoint;
    self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.texture.size];
    self.physicsBody.categoryBitMask = categoryBullets;
    self.physicsBody.contactTestBitMask = categoryPlayers | categoryBlocks;
    self.physicsBody.collisionBitMask = 0x0;
//    self.physicsBody.dynamic = NO;

//    self.physicsBody.mass = 1000;
    self.physicsBody.affectedByGravity = NO;

    if (!self) {
        return NULL;
    }
    return self;
}


@end
