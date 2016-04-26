//
//  OutActivityViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutActivityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property(atomic,retain) IBOutlet UITableView *activityTableView;

-(IBAction)outAll:(id)sender;
-(IBAction)outJiangzuo:(id)sender;
-(IBAction)outGongyi:(id)sender;
-(IBAction)outBisai:(id)sender;
-(IBAction)outOther:(id)sender;

@property(nonatomic) NSInteger indexOfAChange;
@property(atomic) NSInteger changeTag;

@property(atomic) NSInteger prideChange;
@property(atomic) NSInteger opposeChange;
@property(atomic) NSInteger commentChange;
@property(atomic,retain) NSString *currentActivityId;


@end
