//
//  RMPlayerSprite.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRPlayerSprite.h"

@implementation MRPlayerSprite

- (id)initWithPlayerType:(MRPlayerType)type
{
    if (type == kMyPlayer) {
        self = [super initWithColor:[UIColor greenColor] size:CGSizeMake(20, 20)];
    } else if (type == kOtherPlayer) {
        self = [super initWithColor:[UIColor redColor] size:CGSizeMake(20, 20)];
    }

    if (!self) {
        return NULL;
    }
    return self;
}

@end;
