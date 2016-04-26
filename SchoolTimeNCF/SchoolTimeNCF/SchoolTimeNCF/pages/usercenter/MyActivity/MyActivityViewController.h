//
//  MyActivityViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *activityTableView;

@end
