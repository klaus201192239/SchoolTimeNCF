//
//  MyActivityDetailViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/21.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>



@property(atomic,retain) IBOutlet UITableView *myTableView;

-(IBAction)quitAttendActivity:(id)sender;

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

@end
