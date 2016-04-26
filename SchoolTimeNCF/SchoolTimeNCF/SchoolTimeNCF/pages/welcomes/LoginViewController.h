//
//  LoginViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>

@property (nonatomic,retain) IBOutlet UITextField *phoneEdit;
@property (nonatomic,retain) IBOutlet UITextField *pwdEdit;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)bt_login:(id)sender;
-(IBAction)bt_register:(id)sender;
-(IBAction)bt_pwd:(id)sender;

@end
