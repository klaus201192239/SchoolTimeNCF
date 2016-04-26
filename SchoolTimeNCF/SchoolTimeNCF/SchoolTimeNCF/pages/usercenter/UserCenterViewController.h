//
//  PersonalCenterViewController.h
//  7
//
//  Created by OurEDA on 15/12/10.
//  Copyright (c) 2015年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pc_tableView;

@property(strong,nonatomic) NSArray *listname;

@property(nonatomic) NSInteger changeTag;

@end
