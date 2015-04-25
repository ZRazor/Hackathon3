//
//  MRGameOverViewController.m
//  lastwar
//
//  Created by ZRazor on 25.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRGameOverViewController.h"

@interface MRGameOverViewController ()

@end

@implementation MRGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_matchError) {
        self.textLabel.text = @"Ошибка соединения";
    } else if (_didWin) {
        self.textLabel.text = @"Вы выиграли";
    } else {
        self.textLabel.text = @"Вы проиграли";
    }
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

@end
