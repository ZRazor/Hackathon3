//
//  RMPlayerSprite.h
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum
{
    kMyPlayer = 1,
    kOtherPlayer = 2,
} MRPlayerType;

@interface MRPlayerSprite : SKSpriteNode

- (id)initWithPlayerType:(MRPlayerType)type;

@end
