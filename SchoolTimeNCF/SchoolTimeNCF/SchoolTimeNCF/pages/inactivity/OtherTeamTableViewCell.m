//
//  OtherTeamTableViewCell.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/17.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "OtherTeamTableViewCell.h"

@implementation OtherTeamTableViewCell


@synthesize imgage;
@synthesize name;
@synthesize leader;
@synthesize password;
@synthesize abstract;
@synthesize need;
@synthesize slogan;


- (void)awakeFromNib {
    // Initialization code
    
    password.transform=CGAffineTransformMakeRotation(M_PI/4);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
