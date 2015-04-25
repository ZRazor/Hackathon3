#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    categoryPlayers = (1 << 0),
    categoryBullets = (1 << 1),
    categoryBlocks = (1 << 2)
};