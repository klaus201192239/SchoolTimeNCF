//
//  JoinTeamViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinTeamViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic,retain) NSString *activityId;
@property(nonatomic,retain) NSString *teamid;
@property(nonatomic,retain) NSString *leader;
@property(nonatomic,retain) NSString *name;

@property(atomic,retain) IBOutlet UILabel *nameLabel;
@property(atomic,retain) IBOutlet UILabel *leaderLabel;
@property(atomic,retain) IBOutlet UITextField *indroduce;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)upload:(id)sender;


@end
