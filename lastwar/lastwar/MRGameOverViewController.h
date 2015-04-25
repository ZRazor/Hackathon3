//
//  MRGameOverViewController.h
//  lastwar
//
//  Created by ZRazor on 25.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRGameOverViewController : UIViewController
@property BOOL didWin;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
