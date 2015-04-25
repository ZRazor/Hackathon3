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

@interface MRMenuViewController ()

@end

@implementation MRMenuViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (MULTI_PLAYER) {
        [_findGameButton setEnabled:YES];
        return;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)playerAuthenticated {
    [_findGameButton setEnabled:YES];
}

@end
