//
//  TeamMemberBean.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamMemberBean : NSObject

@property(atomic,retain) NSString *userid;
@property(atomic,retain) NSString *name;
@property(atomic,retain) NSString *major;
@property(atomic,retain) NSString *phone;
@property(atomic,retain) NSString *abstracts;
@property(atomic,retain) NSString *idcard;
@property(atomic) NSInteger degree;
@property(atomic) NSInteger grade;
@property(atomic) NSInteger state;

@end
