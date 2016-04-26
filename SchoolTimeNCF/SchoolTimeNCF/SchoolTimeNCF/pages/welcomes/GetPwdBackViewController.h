//
//  GetPwdBackViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/9.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GetPwdBackViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>

@property (nonatomic,retain) IBOutlet UITextField *phone;
@property (nonatomic,retain) IBOutlet UITextField *email;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)bt_onclick:(id)sender;

@end
