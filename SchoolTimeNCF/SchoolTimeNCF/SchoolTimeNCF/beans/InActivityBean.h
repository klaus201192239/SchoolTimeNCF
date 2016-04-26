//
//  InActivityBean.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InActivityBean : NSObject

@property(atomic,retain) NSString *_id;
@property(atomic,retain) NSString *title;
@property(atomic,retain) NSString *imgurl;
@property(atomic,retain) NSString *category;
@property(atomic,retain) NSDate *deadline;
@property(atomic,retain) NSString *time;
@property(atomic) NSInteger pridenum;
@property(atomic) NSInteger opposenum;
@property(atomic) NSInteger commentnum;
@property(atomic) NSInteger onlyteam;


@end
