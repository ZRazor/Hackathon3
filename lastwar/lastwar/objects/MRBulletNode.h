//
//  MRBulletNode.h
//  lastwar
//
//  Created by Зинов Михаил  on 25.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MRBulletNode : SKSpriteNode

@property NSInteger damage;
@property CGPoint startPoint;

-(instancetype)initWithSpeed:(NSInteger)speed AndDamage:(NSInteger)damage AndStartPoint:(CGPoint)startPoint;

@end
