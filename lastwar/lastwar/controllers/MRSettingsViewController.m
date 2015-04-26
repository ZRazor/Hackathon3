//
//  MRSettingsViewController.m
//  lastwar
//
//  Created by Зинов Михаил  on 26.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRSettingsViewController.h"

@interface MRSettingsViewController ()

@end

@implementation MRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_switchOffline setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"offline"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:[_switchOffline isOn]  forKey:@"offline"];
}

- (IBAction)baskAction:(id)sender {
    //!!
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
