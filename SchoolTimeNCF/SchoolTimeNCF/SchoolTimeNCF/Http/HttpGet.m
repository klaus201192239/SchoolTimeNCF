//
//  HttpGet.m
//  SchoolTimeN
//
//  Created by OurEDA on 15/12/3.
//  Copyright (c) 2015年 Klausllt. All rights reserved.
//

#import "HttpGet.h"

@implementation HttpGet

+(NSString *)DoGet:(NSString *) myurl{
    
    //NSString *result;
    
    
    NSURL *url = [NSURL URLWithString:myurl];
    
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];

    NSError *error=nil;
    
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];

        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    str= [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if(str.length>5){
        
        if([[str substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"<?xml"]){
            
            return @"error";
        }
        
    }
    
    
    
    return str;

}


//如果改URL不需要设置参数，则property参数设置为nil

+(NSString *)DoGet:(NSString *)interfaceName property:(NSString *)property {

    NSString * myurl;
    
    extern NSString *ServerUrl;
    
    NSString * urlServer=ServerUrl;

    if(property==nil){

        myurl=[urlServer stringByAppendingString:interfaceName];
        
    }else{

        
        NSString * myurlA=[interfaceName stringByAppendingString:@"?"];
        NSString * myurlB=[myurlA stringByAppendingString:property];

        myurl=[NSString stringWithFormat:@"%@%@",urlServer,myurlB];
        
        
        //NSLog(myurl);
        
        //myurl=[urlServer stringByAppendingString:myurlB];
        
    }
    
    //NSLog(myurl);

    NSURL *url = [NSURL URLWithString:myurl];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    str= [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    if(str.length>5){
        
        if([[str substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"<?xml"]){
            
            return @"error";
        }
        
    }
    
    //NSLog(str);
    
    return str;
}

+(NSString *)DoPost:(NSString *)interfaceName property:(NSString *)property {
    
    extern NSString *ServerUrl;
    
    NSString * urlServer=[NSString stringWithFormat:@"%@/%@",ServerUrl,interfaceName];
    
    NSURL * URL = [NSURL URLWithString:[urlServer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * postString = property;
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *str = [[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    str= [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    if(str.length>5){
        
        if([[str substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"<?xml"]){
            
            return @"error";
        }
        
    }

    return str;
    
}

/*-(void)abc{
    
    
    NSString * URLString = @"http://webservice.webxml.com.cn/WebServices/WeatherWS.asmx/getSupportCityString";
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * postString = @"theRegionCode=广东";
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *aString = [[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding];
    
    NSLog(aString);
    
    
}*/

@end
