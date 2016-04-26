//
//  ManagerActivityNoticeViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerActivityNoticeViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contectText;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *orgnizationid;
@property(nonatomic,retain) NSString *tit;
@property(nonatomic,retain) NSString *orgnization;

-(IBAction)finish:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
