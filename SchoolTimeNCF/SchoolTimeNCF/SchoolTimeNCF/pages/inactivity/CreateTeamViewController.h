//
//  CreateTeamViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTeamViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *from;
@property(nonatomic,retain) NSString *activityname;

@property (nonatomic,retain) IBOutlet UITextField *name;
@property (nonatomic,retain) IBOutlet UITextField *slogan;
@property (nonatomic,retain) IBOutlet UITextField *Abstract;
@property (nonatomic,retain) IBOutlet UITextField *need;
@property (nonatomic,retain) IBOutlet UITextField *Password;
@property (nonatomic,retain) IBOutlet UILabel *leader;
@property (nonatomic,retain) IBOutlet UIImageView *choose;
@property (nonatomic,retain) IBOutlet UILabel *label;

-(IBAction)upload:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@property(atomic,retain) IBOutlet UIImageView *otherTeamImg;

@end

