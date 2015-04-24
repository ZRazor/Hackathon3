#import "MRGameKitHelper.h"

typedef uint32_t MoveDirection;
#define moveLeft 1
#define moveRight 2

//fix for 64 bit
typedef unsigned int MYSUInteger;

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)setCurrentPlayerIndex:(NSUInteger)index;
- (void)movePlayerAtIndex:(NSUInteger)index direction:(MoveDirection)direction;
- (void)gameOver:(BOOL)player1Won;
- (void)setPlayerAliases:(NSArray*)playerAliases;
@end

@interface MRMultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;
- (void)sendMove:(MoveDirection)direction;
- (void)sendGameEnd:(BOOL)player1Won;
@end
