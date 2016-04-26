//
//  InActivityCommentHeader.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InActivityCommentHeader : UITableViewCell


@property(atomic,retain) IBOutlet UILabel *title;
@property(atomic,retain) IBOutlet UIImageView *imgage;
@property(atomic,retain) IBOutlet UILabel *categery;
@property(atomic,retain) IBOutlet UILabel *time;
@property(atomic,retain) IBOutlet UILabel *deadline;


@end
