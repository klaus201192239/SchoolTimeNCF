//
//  TeamMemberAll.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamMemberAll : NSObject

@property(atomic,retain) NSString *_id;
@property(atomic,retain) NSString *IdCard;
@property(atomic,retain) NSString *Name;
@property(atomic,retain) NSString *MajorName;
@property(atomic) NSInteger Degree;
@property(atomic) NSInteger Grade;
@property(atomic,retain) NSString *Phone;
@property(atomic) NSInteger State;
@property(atomic,retain) NSString *StuId;
@property(atomic,retain) NSString *Abstract;
@property(atomic,retain) NSDate *NowTeam;


@end
