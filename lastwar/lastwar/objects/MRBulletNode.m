//
//  MRBulletNode.m
//  lastwar
//
//  Created by Зинов Михаил  on 25.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRBulletNode.h"

@implementation MRBulletNode

-(instancetype)initWithSpeed:(NSInteger)speed AndDemage:(NSInteger)demage AndStartPoint:(CGPoint)startPoint;
{
    self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(2, 4)];
    
    self.demage = demage;
    self.speed = speed;
    self.position = startPoint;
    
    if (!self) {
        return NULL;
    }
    return self;
}


@end
