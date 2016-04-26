//
//  ManagerActivityListViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerActivityListViewController : UIViewController

@property(retain,nonatomic) NSString *oganizationid;
@property(atomic,retain) IBOutlet UITableView *activityTableView;

@end
