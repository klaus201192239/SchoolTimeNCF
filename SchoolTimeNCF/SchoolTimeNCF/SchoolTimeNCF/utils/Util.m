//
//  Util.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/4.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "Util.h"


@implementation Util

+(void)initLocalData{
    
    extern NSMutableArray *InActivityArray;
    extern NSMutableArray *OutActivityArray;
    extern NSMutableArray *MyActivityArray;
    extern Boolean NetLink;
    extern NSString *ServerUrl;
    extern NSString *LoginDate;
    extern NSMutableDictionary *NoticeTagDic;
    extern NSInteger CountNotice;

    
    NetLink=true;
    //ServerUrl=@"http://114.215.135.115:8080/coreservlet/";
    ServerUrl=@"http://114.215.87.133:8080/schooltime/coreservlet/";
    InActivityArray=[[NSMutableArray alloc]init];
    OutActivityArray=[[NSMutableArray alloc]init];
    MyActivityArray=[[NSMutableArray alloc]init];
    
    LoginDate=[Util stringFromDate:[[NSDate alloc]init]];
    
    
    NoticeTagDic=[[NSMutableDictionary alloc]init];
    CountNotice=0;
    
}


+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];

    //[dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];

    NSString *destDateString = [dateFormatter stringFromDate:date];

    /*
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
     */
    
    
    return destDateString;
    
}

+(NSDate *)dateFromString:(NSString *)stringDate{
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:stringDate];
    return date;*/
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    NSDate *date = [formatter dateFromString:stringDate];
    return date;
    
}
+(Boolean)isMobileNO:(NSString *)phone{
    if (phone.length < 11)
    {
       
        return false;
        
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        Boolean isMatch1 = [pred1 evaluateWithObject:phone];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:phone];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:phone];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return true;
        }else{
            return false;
        }
    }
    return true;
}

+(Boolean)isPwdNO:(NSString *)pwd{

    NSString *geshi= @"[a-zA-Z0-9_]+$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", geshi];
    
    if([pred1 evaluateWithObject:pwd]){
        return true;
    }
    else{
        return false;
    }
    
}


+(Boolean)isEmailNO:(NSString *)email{
    
    NSString *check = @"^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", check];
    
    if([pred1 evaluateWithObject:email]){
        return true;
    }
    else{
        return false;
    }
    
}

+(Boolean)isRealName:(NSString *)realname{
    
    NSString *check = @"[a-zA-Z\u4e00-\u9fa5]+$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", check];
    
    if([pred1 evaluateWithObject:realname]){
        return true;
    }
    else{
        return false;
    }
    
}


+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}



@end
