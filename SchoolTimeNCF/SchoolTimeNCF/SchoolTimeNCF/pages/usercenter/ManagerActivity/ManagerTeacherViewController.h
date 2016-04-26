//
//  ManagerTeacherViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerTeacherViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField *phoneEdit;
@property (nonatomic,retain) IBOutlet UITextField *pwdEdit;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)bt_login:(id)sender;

@end
