//
//  RegisterUserViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/9.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RegisterUserViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>

@property (nonatomic,retain) IBOutlet UITextField *EditPhone;
@property (nonatomic,retain) IBOutlet UITextField *EditPwda;
@property (nonatomic,retain) IBOutlet UITextField *EditPwdb;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)bt_onclick:(id)sender;

@end
