//
//  MRSettingsViewController.h
//  lastwar
//
//  Created by Зинов Михаил  on 26.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *switchOffline;
- (IBAction)switchAction:(id)sender;

- (IBAction)baskAction:(id)sender;

@end
