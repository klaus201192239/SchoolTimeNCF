//
//  CallOverViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallOverViewController : UIViewController

@property(nonatomic,retain) NSString *activityid;
@property(nonatomic,retain) NSString *orgnization;
@property(nonatomic,retain) NSString *titl;
@property(nonatomic,retain) NSString *orgnizationid;
@property(nonatomic,retain) NSString *contenthtml;
@property(nonatomic,retain) NSString *attachmentname;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *geoImage;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UITextField *hourText;
@property (weak, nonatomic) IBOutlet UITextField *minText;
@property (weak, nonatomic) IBOutlet UILabel *minuLabel;

-(IBAction)press:(id)sender;
-(IBAction)backgroundTap:(id)sender;
@end
