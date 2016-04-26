//
//  MyActivityCommentViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/21.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property(atomic,retain) IBOutlet UITableView *myTableView;
@property(atomic,retain) IBOutlet UITextField *inputComment;

-(IBAction)uploadComment:(id)sender;



@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *from;
@property(nonatomic,retain) NSString *titl;
@property(nonatomic,retain) NSString *imgurl;
@property(nonatomic,retain) NSString *category;
@property(nonatomic,retain) NSDate *deadline;
@property(nonatomic,retain) NSString *time;


@end
