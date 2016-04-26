//
//  SignInBean.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/21.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInBean : NSObject

@property(atomic,retain) NSString *_id;
@property(atomic,retain) NSString *name;
@property(atomic,retain) NSString *major;
@property(atomic,retain) NSString *studentid;
@property(atomic) NSInteger degree;
@property(atomic) NSInteger grade;
@property(atomic) NSInteger state;



@end
