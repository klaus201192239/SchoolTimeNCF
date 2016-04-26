//
//  InActivityCommentViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/14.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InActivityCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(atomic,retain) IBOutlet UITableView *myTableView;
@property(atomic,retain) IBOutlet UITextField *inputComment;

-(IBAction)uploadComment:(id)sender;

@property(nonatomic) NSInteger indexOfArray;
@property(nonatomic,retain) NSString *from;

@end
