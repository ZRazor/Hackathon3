//
// Created by ZRazor on 25.04.15.
// Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRBlockNode.h"
#import "masks.h"


@implementation MRBlockNode {

}

- (id)initWithPosition:(CGPoint)point;
{
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"box-2"] color:nil size:CGSizeMake(32, 32)];

    self.hp = 100;

    self.physicsBody =
            [SKPhysicsBody bodyWithRectangleOfSize:self.texture.size];
    self.physicsBody.categoryBitMask = categoryBlocks;
    self.physicsBody.contactTestBitMask = categoryBullets;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.usesPreciseCollisionDetection = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.position = point;

    if (!self) {
        return NULL;
    }
    return self;
}
@end