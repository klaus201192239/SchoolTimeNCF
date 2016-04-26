//
//  ChooseOrganizationViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseOrganizationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView *myTable;

@property(retain,nonatomic) NSMutableArray *oganization;



@end
