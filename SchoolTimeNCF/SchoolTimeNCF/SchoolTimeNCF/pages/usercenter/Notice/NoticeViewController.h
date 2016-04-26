//
//  NoticeViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/16.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

//@property(strong,nonatomic) NSMutableArray *noticeArray;

@property(atomic,retain) IBOutlet UITableView *myTableView;


@end
