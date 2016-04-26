//
//  ManagerActivityPersonViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerActivityPersonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *myTableView;

-(IBAction)qunfa:(id)sender;

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *orgnizationid;
@property(nonatomic,retain) NSString *tit;
@property(nonatomic,retain) NSString *orgnization;

@end
