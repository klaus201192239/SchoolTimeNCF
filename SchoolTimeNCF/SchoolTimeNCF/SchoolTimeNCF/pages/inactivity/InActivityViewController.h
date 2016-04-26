//
//  InActivityViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InActivityHeaderCell.h"
#import "InActivityItemCell.h"

@interface InActivityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(atomic,retain) IBOutlet UITableView *activityTableView;
@property(atomic) NSInteger changeTag;
@property(atomic) NSInteger changeCommentTag;


@property (nonatomic,strong) InActivityHeaderCell *headerCell;
@property (nonatomic,strong) InActivityItemCell *itemCell;

@end
