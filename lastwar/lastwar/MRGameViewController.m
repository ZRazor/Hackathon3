//
//  MRGameViewController.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRGameViewController.h"
#import "GameScene.h"
#import "MRMultiplayerNetworking.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];

    return scene;
}

@end

@implementation MRGameViewController {
    MRMultiplayerNetworking *_networkingEngine;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    SKView *skView = (SKView*)self.view;

    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    // Create and configure the scene.
    GameScene * scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    scene.gameEndedBlock = ^() {

    };

    scene.gameOverBlock = ^(BOOL didWin) {
//        GameOverViewController *gameOverViewController = (GameOverViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
//        gameOverViewController.didWin = didWin;
//        [self.navigationController pushViewController:gameOverViewController animated:YES];
    };
    // Present the scene.
    [skView presentScene:scene];

    _networkingEngine = [[MRMultiplayerNetworking alloc] init];
    _networkingEngine.delegate = scene;
    scene.networkingEngine = _networkingEngine;

    [[MRGameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:_networkingEngine];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
