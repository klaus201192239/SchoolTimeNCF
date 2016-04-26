//
//  InActivityDetailUIViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/14.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InActivityDetailUIViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic) NSInteger indexOfArray;
@property(atomic) NSInteger changeTag;
//@property(atomic) NSInteger changeCommentTag;

@property(atomic,retain) IBOutlet UITableView *myTableView;

-(IBAction)attendActivity:(id)sender;

@end
