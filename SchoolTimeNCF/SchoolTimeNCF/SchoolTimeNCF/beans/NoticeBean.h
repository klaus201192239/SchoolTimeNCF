//
//  NoticeBean.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/16.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeBean : NSObject

@property(atomic) NSInteger _id;
@property(atomic,retain) NSString *title;
@property(atomic,retain) NSString *publisher;
@property(atomic,retain) NSString *content;
@property(atomic,retain) NSDate *time;
@property(atomic,retain) NSString *cid;
@property(atomic) NSInteger type;

@end
