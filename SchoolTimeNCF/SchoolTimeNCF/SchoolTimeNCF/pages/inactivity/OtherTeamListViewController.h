//
//  OtherTeamListViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/17.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTeamListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *teamTableView;
@property(atomic,retain) IBOutlet UIImageView *createTeamImg;
//@property(atomic,retain) IBOutlet UIImageView *otherTeamImg;
@property(nonatomic,retain) NSString *activityId;
@property(nonatomic,retain) NSString *activityName;

@end
