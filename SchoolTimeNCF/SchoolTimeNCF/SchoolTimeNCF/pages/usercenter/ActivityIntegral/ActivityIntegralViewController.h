//
//  ActivityIntegralViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/20.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIntegralViewController : UIViewController<UITableViewDataSource,UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UITableView *typeTable;
@property (weak, nonatomic) IBOutlet UITableView *yearTable;
//@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UILabel *typeTileLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

-(IBAction)pressYearButton:(id)sender;
-(IBAction)backgroundTap:(id)sender;


@end
