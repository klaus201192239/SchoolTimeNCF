//
//  HttpGet.h
//  SchoolTimeN
//
//  Created by OurEDA on 15/12/3.
//  Copyright (c) 2015年 Klausllt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpGet : NSObject

+(NSString *)DoGet:(NSString *) myurl;
+(NSString *)DoGet:(NSString *)interfaceName property:(NSString *)property ;
+(NSString *)DoPost:(NSString *)interfaceName property:(NSString *)property ;

@end
