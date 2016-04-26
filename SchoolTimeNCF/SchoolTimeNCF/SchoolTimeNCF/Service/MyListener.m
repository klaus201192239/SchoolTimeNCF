//
//  MyListener.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "MyListener.h"
#import "DBHelper.h"
#import "HttpGet.h"
#import "NoticeBean.h"
#import "MyJson.h"
#import "TeamAll.h"
#import "TeamMemberAll.h"
#import "Util.h"
#import <UIKit/UIKit.h>

@implementation MyListener

-(void)UpdateNotice{
    
    NSMutableArray *noticeArray=[[NSMutableArray alloc]init];
    
    
    NSString *cid0=@"0" , *cid1=@"0" ;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];

    DBHelper *db=[[DBHelper alloc]init];
    
    [db CreateOrOpen];
    
    
   //[db excuteInfo:@"delete from notice"];

    FMResultSet *rs=[db QueryResult:@"select max(cid) from notice where type=1;"];
    
    while ([rs next])
    {
        
        cid0=[rs stringForColumnIndex:0];
        
    }
    
    if(cid0==nil){
        cid0=@"0" ;

    }
    
    FMResultSet *rs1=[db QueryResult:@"select max(cid) from notice where type=2;"];
    
    while ([rs1 next])
    {
        cid1=[rs1 stringForColumnIndex:0];
        
    }
    
    [db CloseDB];
    
    if(cid1==nil){
        cid1=@"0" ;
        
    }

    
    
    NSString *pro=[NSString stringWithFormat:@"userid=%@&currentid=%@",userid,cid0];

    
    NSString * httpjson=[HttpGet DoGet:@"getschoolnotice" property:pro];

    
    if([httpjson isEqualToString:@"error"]){

        
    }else{
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson];
        for(int i=0;i<[array count];i++){
            
            NSMutableDictionary *dic=[array objectAtIndex:i];
            
            NoticeBean *bean=[[NoticeBean alloc]init];

            bean.cid = [dic objectForKey:@"_id"];
            bean.content =[dic objectForKey:@"Content"];
            bean.publisher = [dic objectForKey:@"OrganizationName"];
            bean.time = [dic objectForKey:@"ReleaseTime"];
            bean.title = [dic objectForKey:@"Title"];
            bean.type = 1;
            
            [noticeArray addObject:bean];
            
        }
        
        
    }
    
    
    
    NSString *pro1=[NSString stringWithFormat:@"userid=%@&currentid=%@",userid,cid1];
    
    NSString * httpjson1=[HttpGet DoGet:@"getsystemnotice" property:pro1];

    
    if([httpjson1 isEqualToString:@"error"]){
        
        
    }else{
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson1];
        for(int i=0;i<[array count];i++){
            
            NSMutableDictionary *dic=[array objectAtIndex:i];
            
            NoticeBean *bean=[[NoticeBean alloc]init];
            
            bean.cid = [dic objectForKey:@"_id"];
            bean.content =[dic objectForKey:@"Content"];
            bean.publisher = [dic objectForKey:@"Publisher"];
            bean.time = [dic objectForKey:@"ReleaseTime"];
            bean.title = [dic objectForKey:@"Title"];
            bean.type = 2;
            
            [noticeArray addObject:bean];
            
        }
        
        
    }

    
    
    if([noticeArray count]>0){
        
        [db CreateOrOpen];
        
        for (int i = 0; i < [noticeArray count]; i++) {
            
            NoticeBean *bean =[noticeArray objectAtIndex:i];
            
            NSString *sql=[NSString stringWithFormat:@"insert into notice (title,publisher,content,time,cid,type) values('%@','%@','%@','%@','%@',%ld);",bean.title,bean.publisher,bean.content,bean.time,bean.cid,bean.type];
            
            [db excuteInfo:sql];
            
        }
        
        [db CloseDB];
        
    }
    
    
    if([noticeArray count]>0){
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        id RegisterFirst=[userDefaults objectForKey:@"NoticeFirst"];
        
        if(RegisterFirst ==nil){

            [userDefaults setObject:@"1" forKey:@"NoticeFirst"];
            
            [userDefaults synchronize];

            
        }else{
            
            for (int i = 0; i < [noticeArray count]; i++) {
                
                NoticeBean *bean =[noticeArray objectAtIndex:i];
                
                [self registerLocalNotification:bean.title Content:bean.content];
                
            }
            
            
        }

        
    }

    
}

-(void)UpdateTeam{
    
    NSMutableArray *listTeam=[[NSMutableArray alloc]init];
    NSMutableArray *listMember=[[NSMutableArray alloc]init];
    NSMutableArray *listTT=[[NSMutableArray alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userid=[userDefaults objectForKey:@"Id"];
    NSString *idcard=[userDefaults objectForKey:@"StudentId"];
    NSString *schoolid=[userDefaults objectForKey:@"ShoolId"];
    
    int tag=0;
    
    NSString *pro1=[NSString stringWithFormat:@"userid=%@&idcard=%@&schoolid=%@",userid,idcard,schoolid];
    
    NSString * httpjson1=[HttpGet DoGet:@"getupdateteam" property:pro1];
    
    if([httpjson1 isEqualToString:@"error"]){
        
        
    }else{
        
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson1];
        for(int i=0;i<[array count];i++){
            
            NSMutableDictionary *dic=[array objectAtIndex:i];
            
            TeamAll *team=[[TeamAll alloc]init];
            
            team._id=[dic objectForKey:@"_id"];
            team.LeaderName=[dic objectForKey:@"LeaderName"];
            team.Name=[dic objectForKey:@"Name"];
            team.ActivityName=[dic objectForKey:@"ActivityName"];
            team.TeamLeader=[dic objectForKey:@"TeamLeader"];
            team.IdCard=[dic objectForKey:@"IdCard"];
            
            
            NSMutableArray *arrayMem=[dic objectForKey:@"Member"];
            for(int j=0;j<[arrayMem count];j++){
                
                NSMutableDictionary *objMem=[arrayMem objectAtIndex:j];
                
                TeamMemberAll *member=[[TeamMemberAll alloc]init];

                member._id=[dic objectForKey:@"_id"];
                NSNumber *a=[objMem objectForKey:@"Degree"];
                member.Degree=[a integerValue];
                NSNumber *b=[objMem objectForKey:@"Grade"];
                member.Grade=[b integerValue];
                member.MajorName=[objMem objectForKey:@"MajorName"];
                member.Name=[objMem objectForKey:@"Name"];
                member.Phone=[objMem objectForKey:@"Phone"];
                NSNumber *c=[objMem objectForKey:@"State"];
                member.State=[c integerValue];
                member.StuId=[objMem objectForKey:@"StuId"];
                member.Abstract=[objMem objectForKey:@"Abstract"];
                member.IdCard=[objMem objectForKey:@"IdCard"];
                member.NowTeam = [Util dateFromString:[objMem objectForKey:@"NowTime"]];
                
                [listMember addObject:member];

            }
            
            [listTeam addObject:team];
            
        }

        tag=1;
        
        
        if(tag==1&&[listTeam count]>0){
            
            DBHelper *db=[[DBHelper alloc]init];
            
            [db CreateOrOpen];
            
            for(int i=0;i<[listTeam count];i++){
                
                TeamAll *team=[listTeam objectAtIndex:i];
                
                NSString *idd=nil;
                
                FMResultSet *rs=[db QueryResult:[NSString stringWithFormat:@"select id from myteam where id='%@';",team._id]];
                
                while ([rs next])
                {
                    idd=[rs stringForColumnIndex:0];
                    
                }
                
                if(idd==nil){
                    NoticeBean *bean =[[NoticeBean alloc]init];
                    bean.publisher=@"校园时光官方通知";
                    
                    if([userid isEqualToString:team.TeamLeader]||[idcard isEqualToString:team.IdCard]){
                        
                        bean.title=@"团队已成功创建";
                        bean.content=[NSString stringWithFormat:@"您好，你带领的团队：%@已经成功创建了，请及时在<我的团队>管理板块中，对您的团队进行管理〜祝好运！",team.Name];
                        
                    }else{
                        bean.title=@"您已成为团队一员";
                        bean.content=[NSString stringWithFormat:@"您好，您已经成功加入团队：%@，可以在<我的团队>管理板块中，查看您的队友信息〜祝好运！",team.Name];
                        
                    }
                    
                    [listTT addObject:bean];
                    
                }else{
                    
                    for(int j=0;j<[listMember count];j++){
                        
                        TeamMemberAll *member1=[listMember objectAtIndex:j];
                        
                        if([member1._id isEqualToString:idd]){
                            
                            
                            FMResultSet *rs1=[db QueryResult:[NSString stringWithFormat:@"select teamid,state from teammember where teamid='%@' and userid='%@' and idcard='%@';",idd,member1.StuId,member1.IdCard]];
                            
                            NSString *sre=nil;
                            int sta=-1;
                            
                            while ([rs1 next])
                            {
                                sre=[rs1 stringForColumnIndex:0];
                                sta=[rs1 intForColumnIndex:1];
                            }
                            
                            if(sre==nil){
                                
                                NoticeBean *bean = [[NoticeBean alloc]init];
                                bean.publisher=@"校园时光官方通知";
                                bean.title=@"团对有新成员加入";
                                bean.content=[NSString stringWithFormat:@"您好，%@团队有新成员加入，可以在<我的团队>管理板块中，查看您的队友信息〜祝好运！",team.Name];
                                
                                [listTT addObject:bean];
                                
                            }else{
                                
                                if(sta!=-1&&(member1.State!=sta)){
                                    
                                    NoticeBean *bean = [[NoticeBean alloc]init];
                                    bean.publisher=@"校园时光官方通知";
                                    bean.title=@"团对成员状态变化";
                                    bean.content=[NSString stringWithFormat:@"您好，%@团队中的成员，%@已经审核通过，并正式成为你们之中的一员。可以在<我的团队>管理板块中，查看您的队友信息〜祝好运！",team.Name,member1.Name];
                                    
                                    [listTT addObject:bean];
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            
            NSString *sql=@"select id,name,leadername,activityname from myteam where ";
            for(int k=0;k<[listTeam count];k++){
                
                TeamAll *team=[listTeam objectAtIndex:k];

                if(k==[listTeam count]-1){
                    
                    sql=[sql stringByAppendingString:[NSString stringWithFormat:@"id<>'%@';",team._id]];
                    
                }else{
                    sql=[sql stringByAppendingString:[NSString stringWithFormat:@"id<>'%@' and ",team._id]];
                    
                }
                
            }
            
            FMResultSet *rs=[db QueryResult:sql];
            while ([rs next])
            {
                
                NSString *_id=[rs stringForColumnIndex:0];
                
                if(_id!=nil){
                    
                    NoticeBean *bean = [[NoticeBean alloc]init];
                    bean.publisher=@"校园时光官方通知";
                    bean.title=@"团对解散通知";
                    bean.content=[NSString stringWithFormat:@"您好，由%@带领的%@团队,已经被解散，如果想继续参加活动，请及时组建其他团队，祝好运~!",[rs stringForColumnIndex:2],[rs stringForColumnIndex:1]];
                    
                    [listTT addObject:bean];
                    
                }
                
            }
            
            sql=@"select id,name,leadername,activityname from myteam where ";
            
            for(int k=0;k<[listTeam count];k++){
                
                TeamAll *team=[listTeam objectAtIndex:k];
                
                if(k==[listTeam count]-1){
                    
                    sql=[sql stringByAppendingString:[NSString stringWithFormat:@"id='%@';",team._id]];
                    
                }else{
                    sql=[sql stringByAppendingString:[NSString stringWithFormat:@"id='%@' or ",team._id]];
                    
                }
                
            }
            
            FMResultSet *rs1=[db QueryResult:sql];
            while ([rs1 next])
            {
                
                NSString *_id=[rs1 stringForColumnIndex:0];
                
                if(_id!=nil){
                    
                    
                    NSString *memSql=[NSString stringWithFormat:@"select name,major,degree,grade,phone from teammember where teamid='%@' and ",_id];
                    
                    for(int h=0;h<[listMember count];h++){
                        
                        TeamMemberAll *member2=[listMember objectAtIndex:h];
                        
                        if([member2._id isEqualToString:_id]){
                            
                            if([member2.StuId isEqualToString:@"000000000000000000000000"]){
                                
                                memSql=[memSql stringByAppendingString:[NSString stringWithFormat:@"idcard<>'%@' and ",member2.IdCard]];
                                
                                
                            }
                            else{
                                
                                memSql=[memSql stringByAppendingString:[NSString stringWithFormat:@"userid<>'%@' and ",member2.StuId]];
                                
                            }
                            
                            
                        }
                    }

                    NSInteger xx=memSql.length-4;
                    
                    memSql=[memSql substringWithRange:NSMakeRange(0,xx)];
                    
                    FMResultSet *rs2=[db QueryResult:memSql];
                    while ([rs2 next])
                    {
                        
                        NoticeBean *bean = [[NoticeBean alloc]init];
                        bean.publisher=@"校园时光官方通知";
                        bean.title=@"团对解散通知";
                        bean.content=[NSString stringWithFormat:@"您好，由%@带领的%@团队,已经被解散，如果想继续参加活动，请及时组建其他团队，祝好运~!",[rs stringForColumnIndex:2],[rs stringForColumnIndex:1]];
                        bean.publisher=@"校园时光官方通知";
                        bean.title=@"团对成员退出通知";
                        bean.content=[NSString stringWithFormat:@"您好，团队成员%@的%@(%@ %@)已经退出%@团队",[rs2 stringForColumnIndex:1],[rs2 stringForColumnIndex:0],[rs2 stringForColumnIndex:3],[rs2 stringForColumnIndex:2],[rs2 stringForColumnIndex:1]];
                        
                        
                        [listTT addObject:bean];
                        
                    }
                }
            }
        }
    }
    
    
    
    
    if ([listTeam count] != 0) {
        
        
        DBHelper *dbh=[[DBHelper alloc]init];
        
        [dbh CreateOrOpen];
        
        [dbh excuteInfo:@"delete from myteam;"];

        for (int i = 0; i < [listTeam count]; i++) {
            
            TeamAll *bean = [listTeam objectAtIndex:i];
            
            NSString *inset= [NSString stringWithFormat:@"insert into myteam values('%@','%@','%@','%@','%@','%@');",bean._id,bean.Name,bean.TeamLeader,bean.IdCard,bean.LeaderName,bean.ActivityName];
            [dbh excuteInfo:inset];

        }
        
        [dbh excuteInfo:@"delete from teammember;"];
        
        NSDate *now=[[NSDate alloc]init];
        
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        NSDate *theDate = [now initWithTimeIntervalSinceNow: -oneDay*6];
        
        for (int i = 0; i < [listMember count]; i++) {
            
            TeamMemberAll *bean =[listMember objectAtIndex:i];
            
            if(bean.State==0){
                
                NSDate *date=bean.NowTeam;
                
               //     theDate      deadline
                
                if([theDate compare:date]==NSOrderedDescending){
                    
                    NSString *pro11=[NSString stringWithFormat:@"teamid=%@&userid=%@&type=0&schoolid=%@&idcard=%@",bean._id,bean.StuId,schoolid,bean.IdCard];
                    
                    [HttpGet DoGet:@"teammanager" property:pro11];

                    NoticeBean *beann = [[NoticeBean alloc]init];
                    beann.publisher=@"校园时光官方通知";
                    beann.title=@"团对成员退出通知";
                    beann.content=[NSString stringWithFormat:@"您好，由于团队成员%@长时间未审核，该队员已经被自动剔除团队，特此通知〜",bean.Name];
                    [listTT addObject:beann];

                    
                }else{
                    NSString *pro11=[NSString stringWithFormat:@"insert into teammember values('%@','%@','%@','%@','%@',%ld,%ld,'%@','%@',%ld);",bean._id,bean.StuId,bean.IdCard,bean.Name,bean.MajorName,bean.Degree,bean.Grade,bean.Phone,bean.Abstract,bean.State];
                    
                    [dbh excuteInfo:pro11];
                    
                }
            }
            else{
                NSString *pro11=[NSString stringWithFormat:@"insert into teammember values('%@','%@','%@','%@','%@',%ld,%ld,'%@','%@',%ld);",bean._id,bean.StuId,bean.IdCard,bean.Name,bean.MajorName,bean.Degree,bean.Grade,bean.Phone,bean.Abstract,bean.State];
                
                [dbh excuteInfo:pro11];
              
            }
            
        }
        
        [dbh CloseDB];
        
        
    }
    
    
    [listTeam removeAllObjects];
    [listMember removeAllObjects];
    
    if ([listTT count] != 0) {
        
        DBHelper *db=[[DBHelper alloc]init];
        
        [db CreateOrOpen];

        NSDate *da=[[NSDate alloc]init];
        
        for (int i = 0; i < [listTT count]; i++) {
            
            NoticeBean *bean = [listTT objectAtIndex:i];
            
            NSString *pro11=[NSString stringWithFormat:@"insert into notice(title,publisher,content,time,cid,type)  values('%@','%@','%@','%@','nothing',3);",bean.title,bean.publisher,bean.content,[Util stringFromDate:da]];
            [db excuteInfo:pro11];
        
        }
        
        [db CloseDB];
    }
    
    
    if([listTT count]>0){
        
        for (int i = 0; i < [listTT count]; i++) {
            
            NoticeBean *bean = [listTT objectAtIndex:i];
            
            [self registerLocalNotification:bean.title Content:bean.content];
            
        }
        
    }

    
}

-(void)registerLocalNotification:(NSString *)title Content:(NSString *)content {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    
    
    extern NSMutableDictionary *NoticeTagDic;
    extern NSInteger CountNotice;
    
    
    // 通知内容
    notification.alertBody = title;
    
   /* if(CountNotice==0){
        
        notification.applicationIconBadgeNumber = 1;
    }
    else{
        
        notification.applicationIconBadgeNumber++;
        
    }*/
    notification.applicationIconBadgeNumber = 0;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数

    
    extern NSMutableDictionary *NoticeTagDic;
    extern NSInteger CountNotice;

    NSString *key=[NSString stringWithFormat:@"%ld",CountNotice];
    CountNotice++;
    [NoticeTagDic setObject:@"0" forKey:key];
    
    
   // NSDictionary *userDict = [NSDictionary dictionaryWithObject:key forKey:@"key"];
    
    
    NSMutableDictionary *userDict=[[NSMutableDictionary alloc]init];
    [userDict setObject:key forKey:@"key"];
    [userDict setObject:title forKey:@"title"];
    [userDict setObject:content forKey:@"content"];
    
    
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}



@end
