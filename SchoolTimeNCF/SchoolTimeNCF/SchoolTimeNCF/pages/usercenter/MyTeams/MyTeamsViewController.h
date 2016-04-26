//
//  MyTeamsViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *teamTableView;

@end
