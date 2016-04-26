//
//  SetPassWordViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPassWordViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldpwd;

@property (weak, nonatomic) IBOutlet UITextField *newpwd;

@property (weak, nonatomic) IBOutlet UITextField *newpwdR;

-(IBAction)getPWDback:(id)sender;
-(IBAction)changePWD:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
