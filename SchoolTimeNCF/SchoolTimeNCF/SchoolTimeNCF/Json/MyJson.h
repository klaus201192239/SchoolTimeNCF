//
//  MyJson.h
//  hiklaus
//
//  Created by OurEDA on 15/11/30.
//  Copyright (c) 2015年 klausllt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyJson : NSObject

+(NSMutableArray *)JsonSringToArray:(NSString *)jsonString;
+(NSMutableDictionary *)JsonSringToDictionary:(NSString *)jsonString;
+(NSString *)ArrayToJsonString:(NSMutableArray *)jsonArry;
+(NSString *)DictionaryToJsonString:(NSMutableDictionary *)jsonDictionary;
@end
