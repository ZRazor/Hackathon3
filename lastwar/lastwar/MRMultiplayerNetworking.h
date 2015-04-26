#import "MRGameKitHelper.h"
#import "matchEndType.h"

typedef float PlayerPosition;
#define moveLeft 1
#define moveRight 2

//fix for 64 bit
typedef unsigned int MYSUInteger;

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)matchDismissed;
- (void)setCurrentPlayerIndex:(NSUInteger)index;
- (void)movePlayerAtIndex:(NSUInteger)index position:(PlayerPosition)position;
- (void)shotPlayerAtIndex:(NSUInteger)index playerPosition:(PlayerPosition)direction;
- (void)gameOver:(MRMatchEndType) endType;
- (void)setPlayerAliases:(NSArray*)playerAliases;
@end

@interface MRMultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;
- (void)sendMove:(PlayerPosition)position;
- (void)sendGameEnd:(BOOL)player1Won;
- (void)sendShot:(PlayerPosition)position;
@end
