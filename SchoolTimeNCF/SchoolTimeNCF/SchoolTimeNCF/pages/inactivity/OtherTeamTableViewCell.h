//
//  OtherTeamTableViewCell.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/17.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTeamTableViewCell : UITableViewCell

@property(atomic,retain) IBOutlet UIImageView *imgage;
@property(atomic,retain) IBOutlet UILabel *name;
@property(atomic,retain) IBOutlet UILabel *leader;
@property(atomic,retain) IBOutlet UILabel *password;
@property(atomic,retain) IBOutlet UILabel *abstract;
@property(atomic,retain) IBOutlet UILabel *need;
@property(atomic,retain) IBOutlet UILabel *slogan;

@end
