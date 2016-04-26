//
//  InActivityDetailTableViewCell.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "InActivityDetailTableViewCell.h"

@implementation InActivityDetailTableViewCell

@synthesize title;
@synthesize organization;
@synthesize imgage;
@synthesize categery;
@synthesize deadline;
@synthesize time;
@synthesize like_num;
@synthesize dislike_num;
@synthesize comment_num;
@synthesize likeBt;
@synthesize dislikeBt;
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
