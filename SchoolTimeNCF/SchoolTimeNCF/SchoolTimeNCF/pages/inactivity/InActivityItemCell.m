//
//  InActivityItemCell.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "InActivityItemCell.h"

@implementation InActivityItemCell


@synthesize title;
@synthesize imgage;
@synthesize categery;
@synthesize deadline;
@synthesize time;
@synthesize like_num;
@synthesize dislike_num;
@synthesize comment_num;
@synthesize sum_num;
@synthesize likeBt;
@synthesize dislikeBt;
@synthesize commentBt;
@synthesize attendBt;


- (void)awakeFromNib {
    // Initialization code
    
    categery.transform=CGAffineTransformMakeRotation(M_PI/4);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
