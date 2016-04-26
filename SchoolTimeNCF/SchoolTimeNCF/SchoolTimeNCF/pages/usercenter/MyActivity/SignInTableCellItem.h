//
//  SignInTableCellItem.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/21.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInTableCellItem : UITableViewCell

@property(atomic,retain) IBOutlet UILabel *name;
@property(atomic,retain) IBOutlet UILabel *major;
@property(atomic,retain) IBOutlet UIImageView *image;


@end
