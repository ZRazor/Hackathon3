//
//  MRGameOverViewController.h
//  lastwar
//
//  Created by ZRazor on 25.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "matchEndType.h"

@interface MRGameOverViewController : UIViewController
@property MRMatchEndType endType;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (IBAction)backToMenuAction:(id)sender;

@end
