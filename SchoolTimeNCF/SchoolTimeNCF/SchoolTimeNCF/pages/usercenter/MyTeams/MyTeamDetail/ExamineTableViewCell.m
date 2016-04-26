//
//  ExamineTableViewCell.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ExamineTableViewCell.h"

@implementation ExamineTableViewCell

@synthesize titleLabel;
@synthesize majorLabel;
@synthesize phoneLabel;
@synthesize summaryLabel;
@synthesize receptButton;
@synthesize refuseButton;
@synthesize checkLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
