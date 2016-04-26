//
//  NoticeDetailViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/16.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;

@property(nonatomic,retain) NSString *tit;
@property(nonatomic,retain) NSString *time;
@property(nonatomic,retain) NSString *content;
@property(nonatomic,retain) NSString *publisher;

@end
