//
//  MyJson.m
//  hiklaus
//
//  Created by OurEDA on 15/11/30.
//  Copyright (c) 2015年 klausllt. All rights reserved.
//

#import "MyJson.h"
#import "JSONKit.h"


@implementation MyJson

+(NSMutableArray *)JsonSringToArray:(NSString *)jsonString{

    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *arrayResult =[jsonData objectFromJSONData];
    
    return arrayResult;
    
}

+(NSMutableDictionary *)JsonSringToDictionary:(NSString *)jsonString{

    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err=nil;
    
    dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    return dictionary;
    
    /*NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableDictionary *resultDict = [jsonData objectFromJSONData];
    
    return resultDict;*/
    
}


+(NSString *)ArrayToJsonString:(NSMutableArray *)jsonArry{
    
    return [jsonArry JSONString];
    
}
+(NSString *)DictionaryToJsonString:(NSMutableDictionary *)jsonDictionary{
    
    return [jsonDictionary JSONString];
    
}





@end
