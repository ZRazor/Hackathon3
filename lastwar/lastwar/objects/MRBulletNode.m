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

-(instancetype)initWithSpeed:(NSInteger)speed AndDemage:(NSInteger)demage AndStartPoint:(CGPoint)startPoint;
{
    self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(3, 6)];
    
    self.demage = demage;
    self.speed = speed;
    self.position = startPoint;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = categoryBullets;
    self.physicsBody.contactTestBitMask = categoryPlayers;
    self.physicsBody.affectedByGravity = NO;

    if (!self) {
        return NULL;
    }
    return self;
}


@end
