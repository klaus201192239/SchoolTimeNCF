//
//  ManagerActivityDetailViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerActivityDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *myTableView;

-(IBAction)startSignIn:(id)sender;

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *from;
@property(nonatomic,retain) NSString *titl;
@property(nonatomic,retain) NSString *imgurl;
@property(nonatomic,retain) NSString *category;
@property(nonatomic,retain) NSDate *deadline;
@property(nonatomic,retain) NSString *time;
@property(nonatomic) NSInteger opposenum;
@property(nonatomic) NSInteger pridenum;
@property(nonatomic) NSInteger commentnum;
@property(nonatomic,retain) NSString *orgnizationid;

@end
