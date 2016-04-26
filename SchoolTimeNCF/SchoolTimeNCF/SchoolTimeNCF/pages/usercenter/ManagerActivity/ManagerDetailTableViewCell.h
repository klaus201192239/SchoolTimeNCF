//
//  ManagerDetailTableViewCell.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerDetailTableViewCell : UITableViewCell


@property(atomic,retain) IBOutlet UILabel *title;
@property(atomic,retain) IBOutlet UILabel *organization;
@property(atomic,retain) IBOutlet UIImageView *imgage;
@property(atomic,retain) IBOutlet UILabel *categery;
@property(atomic,retain) IBOutlet UILabel *time;
@property(atomic,retain) IBOutlet UILabel *deadline;
@property(atomic,retain) IBOutlet UILabel *like_num;
@property(atomic,retain) IBOutlet UILabel *dislike_num;
@property(atomic,retain) IBOutlet UILabel *comment_num;
@property(atomic,retain) IBOutlet UIButton * commentBt;
@property(atomic,retain) IBOutlet UILabel *content;
@property(atomic,retain) IBOutlet UILabel *attachment;

@end
