//
//  MRMenuViewController.m
//  lastwar
//
//  Created by ZRazor on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRMenuViewController.h"
#import "MRGameKitHelper.h"
#import "MRGameViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MRMenuViewController ()
@property(nonatomic) AVAudioPlayer *audio;
@end

@implementation MRMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-rock-black"]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    if (OFFLINE_GAME) {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"offline"]) {
        [_findGameButton setEnabled:YES];
        return;
    } else {
        _findGameButton.enabled = NO;
    }
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(showAuthenticationViewController)
                   name:PresentAuthenticationViewController
                 object:nil];

    [[MRGameKitHelper sharedGameKitHelper]
            authenticateLocalPlayer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated) name:LocalPlayerIsAuthenticated object:nil];
}

- (void)showAuthenticationViewController
{
    MRGameKitHelper *gameKitHelper =
            [MRGameKitHelper sharedGameKitHelper];

    [self presentViewController:
                    gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self playDoor];
    if ([[segue identifier] isEqualToString:@"findGameSegue"]) {
        [MRGameKitHelper sharedGameKitHelper].gameReady = YES;
    }
}


- (void)playerAuthenticated {
    [_findGameButton setEnabled:YES];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
//    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)playDoor
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"door" ofType:@"wav"];
    self.audio = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    [self.audio play];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
