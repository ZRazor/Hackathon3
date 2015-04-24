#import "MRGameKitHelper.h"

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)setCurrentPlayerIndex:(NSUInteger)index;
- (void)movePlayerAtIndex:(NSUInteger)index;
- (void)gameOver:(BOOL)player1Won;
- (void)setPlayerAliases:(NSArray*)playerAliases;
@end

@interface MRMultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;
- (void)sendMove;
- (void)sendGameEnd:(BOOL)player1Won;
@end
