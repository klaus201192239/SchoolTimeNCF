//
//  SignInViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/21.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *myTableView;
-(IBAction)qiandao:(id)sender;

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *titl;

@end
