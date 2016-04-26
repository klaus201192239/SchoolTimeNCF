//
//  OnlySignUpViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlySignUpViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(atomic,retain) IBOutlet UITableView *myTableView;

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *from;
@property(nonatomic) NSInteger teamtag;
@property(nonatomic,retain) NSString *showself;
@property(nonatomic,retain) NSString *teamid;
@property(nonatomic,retain) NSString *teaminfo;
@property(nonatomic,retain) NSString *activityName;

@end
