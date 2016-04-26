//
//  OutActivityDetailViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutActivityDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *myTableView;


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
//@property(nonatomic) NSInteger indexOfArray;


@property(atomic) NSInteger changeTag;
@property(atomic) NSInteger prideChange;
@property(atomic) NSInteger opposeChange;
@property(atomic) NSInteger commentChange;

@end
