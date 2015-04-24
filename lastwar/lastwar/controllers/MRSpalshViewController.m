//
//  MRSpalshViewController.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRSpalshViewController.h"
#import "MRMenuViewController.h"

@interface MRSpalshViewController ()
{
    NSTimer *timer;
}


@end

@implementation MRSpalshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f  target:self selector:@selector(showMainMenuController) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMainMenuController
{
    [self performSegueWithIdentifier:@"mainMenuSegue" sender:self];
}



@end
