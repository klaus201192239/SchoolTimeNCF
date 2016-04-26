//
//  InActivityCommentHeader.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "InActivityCommentHeader.h"

@implementation InActivityCommentHeader

@synthesize title;
@synthesize imgage;
@synthesize categery;
@synthesize deadline;
@synthesize time;

- (void)awakeFromNib {
    // Initialization code
    
    categery.transform=CGAffineTransformMakeRotation(M_PI/4);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
