//
//  RegisterSchoolViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/11.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterSchoolViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView *myTable;
@property(nonatomic,retain) IBOutlet UITableView *cityTable;
@property(nonatomic,retain) IBOutlet UIButton *province;
@property(nonatomic,retain) IBOutlet UIButton *city;

-(IBAction)choosePro:(id)sender;
-(IBAction)chooseCity:(id)sender;
-(IBAction)search:(id)sender;


@property(nonatomic,retain) NSString *choosePro;
@property(nonatomic,retain) NSString *chooseCity;





@property(atomic,retain) NSString *UserId;
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

@end
