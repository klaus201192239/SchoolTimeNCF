//
//  RegisterInfoViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/10.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterInfoViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

//intent.putExtra("From","02");
//intent.putExtra("Phone", Phone);
//intent.putExtra("Pwd", Pwda);

@property(atomic,retain) NSString *From;
@property(atomic,retain) NSString *Phone;
@property(atomic,retain) NSString *Pwd;
@property(atomic,retain) NSString *UserRealName;
@property(atomic) NSInteger Sex;
@property(atomic) NSInteger Degree;
@property(atomic) NSInteger Grade;
@property(atomic,retain) NSString *SchoolId;
@property(atomic,retain) NSString *SchoolName;
@property(atomic,retain) NSString *MajorName;
@property(atomic,retain) NSString *Education;
@property(atomic,retain) NSString *Email;
@property(atomic,retain) NSString *StudentId;
@property(atomic,retain) NSString *MajorId;
@property(atomic,retain) NSMutableArray *MajorInfo;
@property(atomic,retain) NSString *SchoolImg;



@property(atomic,retain) IBOutlet UITextField * realName;
@property(atomic,retain) IBOutlet UIButton * manButton;
@property(atomic,retain) IBOutlet UIButton * womanButton;
@property(atomic,retain) IBOutlet UIButton * schoolButton;
@property(atomic,retain) IBOutlet UIButton * degreeButton;
@property(atomic,retain) IBOutlet UITextField * studentID;
@property(atomic,retain) IBOutlet UIButton * majorButton;
@property(atomic,retain) IBOutlet UIButton * gradeButton;
@property(atomic,retain) IBOutlet UITextField * EamilEdit;
@property(atomic,retain) IBOutlet UITableView * myTableView;
//@property(atomic,retain) IBOutlet UIButton * updateButton;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)chooseMan:(id)sender;
-(IBAction)chooseWoMan:(id)sender;
-(IBAction)chooseSchool:(id)sender;
-(IBAction)update:(id)sender;
-(IBAction)chooseDegree:(id)sender;
-(IBAction)chooseMajor:(id)sender;
-(IBAction)chooseGrade:(id)sender;

@end
