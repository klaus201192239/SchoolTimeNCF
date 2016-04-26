//
//  DBHelper.h
//  hiklaus
//
//  Created by OurEDA on 15/12/1.
//  Copyright (c) 2015年 klausllt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBHelper : NSObject{
    
    FMDatabase *db;
}

-(id)init;

-(Boolean)CreateOrOpen;

-(Boolean)TableExit:(NSString *)tableName;

-(void)excuteInfo:(NSString *)sql;

-(FMResultSet *)QueryResult:(NSString *)sql;

-(void)CloseDB;
  
@end
