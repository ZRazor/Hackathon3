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
    switch (_endType) {
        case kLoseEnd:
            self.textLabel.text = @"Вы проиграли";
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_defeat"]]];
            break;
        case kWinEnd:
            self.textLabel.text = @"Вы выиграли";
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_win"]]];
            break;
        case kErrorEnd:
            self.textLabel.text = @"Ошибка соединения";
            break;
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
