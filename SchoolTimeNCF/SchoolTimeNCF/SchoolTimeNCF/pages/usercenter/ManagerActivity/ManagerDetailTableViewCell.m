//
//  ManagerDetailTableViewCell.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ManagerDetailTableViewCell.h"

@implementation ManagerDetailTableViewCell

@synthesize title;
@synthesize organization;
@synthesize imgage;
@synthesize categery;
@synthesize deadline;
@synthesize time;
@synthesize like_num;
@synthesize dislike_num;
@synthesize comment_num;
@synthesize commentBt;
@synthesize attachment;
@synthesize content;

- (void)awakeFromNib {
    // Initialization code
    
    categery.transform=CGAffineTransformMakeRotation(M_PI/4);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
