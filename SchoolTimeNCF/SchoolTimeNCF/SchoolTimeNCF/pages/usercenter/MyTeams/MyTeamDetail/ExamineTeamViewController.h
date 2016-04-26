//
//  ExamineTeamViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamineTeamViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *memberTabel;
@property (weak, nonatomic) IBOutlet UIButton *existButton;
@property (atomic) NSInteger power;
@property (atomic) NSString * teamid;

-(IBAction)exist:(id)sender;

@end
