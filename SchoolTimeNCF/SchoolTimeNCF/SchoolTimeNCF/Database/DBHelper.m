//
//  DBHelper.m
//  hiklaus
//
//  Created by OurEDA on 15/12/1.
//  Copyright (c) 2015年 klausllt. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper


-(id)init{
    
    if(self=[super init]){

        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"schooltime.sqlite"];
        db=[FMDatabase databaseWithPath:fileName];
        
    }
    
    return self;
}

-(Boolean)CreateOrOpen{
    
    return [db open];
    
}

-(Boolean)TableExit:(NSString *)tableName{
    
    
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    return false;
}

-(void)excuteInfo:(NSString *)sql{
    
    [db executeUpdate:sql];
    
}

-(FMResultSet *)QueryResult:(NSString *)sql{
    
    FMResultSet *resultSet = [db executeQuery:sql];
    
    return  resultSet;
    
}

-(void)CloseDB{
    [db close];
}


//NSString * name=@"klaus";

//NSString *sql = [NSString stringWithFormat:@"SELECT * FROM temt where str='%@';",name];

@end
