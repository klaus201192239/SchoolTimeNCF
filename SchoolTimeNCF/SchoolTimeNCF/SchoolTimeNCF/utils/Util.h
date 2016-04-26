//
//  Util.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/4.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(void)initLocalData;
+(NSString *)stringFromDate:(NSDate *)date;
+(NSDate *)dateFromString:(NSString *)stringDate;
+(Boolean)isMobileNO:(NSString *)phone;
+(Boolean)isPwdNO:(NSString *)pwd;
+(Boolean)isEmailNO:(NSString *)email;
+(Boolean)isRealName:(NSString *)realname;
+(NSString*)encodeString:(NSString*)unencodedString;
+(NSString *)decodeString:(NSString*)encodedString;


@end
