//
//  IntegralDetail.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/22.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralDetail : NSObject

@property(atomic,retain) NSString * Classid;
@property(atomic,retain) NSString * ClassName;
@property(atomic,retain) NSString *name;
@property(atomic,retain) NSString *Scope;
@property(atomic,retain) NSString *Level;
@property(atomic) double Grade;

@end
