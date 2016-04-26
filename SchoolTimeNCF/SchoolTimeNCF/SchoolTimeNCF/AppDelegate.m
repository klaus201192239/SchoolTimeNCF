//
//  AppDelegate.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/3.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h"
#import "LoadDataViewController.h"
#import "HttpGet.h"
#import "DBHelper.h"
#import "InActivityBean.h"
#import "Util.h"
#import "MyListener.h"

@interface AppDelegate (){
    
    NSTimer *timer;
    
    NSInteger tag;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
  
   //NSDictionary* dict = [defs dictionaryRepresentation];
   
   //for(id key in dict) {
       
   // [defs removeObjectForKey:key];
   
  // }
    
  // [defs synchronize];
    

    [Util initLocalData];
    
    
    //start the timer
    
   // timer =  [NSTimer scheduledTimerWithTimeInterval:100.0 target:self /selector:@selector(listenerService:) userInfo:nil repeats:YES];
  //  [timer setFireDate:[NSDate distantPast]];
 //   tag=-1;

    
    
    //开始监听,会启动一个run loop
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [hostReach startNotifier];

    
    
    
    
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    LoadDataViewController *viewController = [[LoadDataViewController alloc]init];
    
    self.window.rootViewController = viewController;
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    
    NSDictionary *dic=notification.userInfo;
    
    NSString *key=[dic objectForKey:@"key"];
    
    
    extern NSMutableDictionary *NoticeTagDic;
    NSString *str=[NoticeTagDic objectForKey:key];

    
    if([@"0" isEqualToString:str]){

        
        [NoticeTagDic setValue:@"1" forKey:key];
        
    }else{


        NSString *titl= [notification.userInfo objectForKey:@"title"];
        NSString *message = [notification.userInfo objectForKey:@"content"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titl
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了~"
                                              otherButtonTitles:nil];
      //  [alert show];
        

        
        
        [NoticeTagDic removeObjectForKey:key];

        [self cancelLocalNotificationWithKey:key];
        
    }
 
}

-(void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
    //stop the timer
    
    [timer setFireDate:[NSDate distantFuture]];
    [timer invalidate];
    timer = nil;

    
    //save the data
    
    extern NSMutableArray *InActivityArray;
    extern NSMutableArray *OutActivityArray;
    extern NSMutableArray *MyActivityArray;
    
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSInteger len = [InActivityArray count];
    
    if(len>20){
        
        len=20;
        
    }
    
    [dbhelper excuteInfo:@"delete from inactivity;"];
    
    for(int i=0;i<len;i++){
        
        InActivityBean *bean=[InActivityArray objectAtIndex:i];
        
        NSString *_id = bean._id;
        NSString *title = bean.title;
        NSString *img = bean.imgurl;
        NSString *cate =bean.category;
        NSString *deadline = [Util stringFromDate:bean.deadline];
        NSString *time = bean.time;
        NSInteger pride = bean.pridenum;
        NSInteger oppose = bean.opposenum;
        NSInteger comment = bean.commentnum;
        NSInteger onlyteam =bean.onlyteam;
        
        NSString *sql=[NSString stringWithFormat:@"insert into inactivity values('%@','%@','%@','%@','%@',,'%@'%ld,%ld,%ld,%ld);",_id,title,img,cate,deadline,time,pride,oppose,comment,onlyteam];
        
        [dbhelper excuteInfo:sql];
        
    }
    
    
    len = [OutActivityArray count];
    
    if(len!=0){
        
        if(len>20){
            
            len=20;
            
        }
        
        [dbhelper excuteInfo:@"delete from outactivity;"];
        
        for(int i=0;i<len;i++){
            
            InActivityBean *bean=[OutActivityArray objectAtIndex:i];
            
            NSString *_id = bean._id;
            NSString *title = bean.title;
            NSString *img = bean.imgurl;
            NSString *cate =bean.category;
            NSString *deadline = [Util stringFromDate:bean.deadline];
            NSString *time = bean.time;
            NSInteger pride = bean.pridenum;
            NSInteger oppose = bean.opposenum;
            NSInteger comment = bean.commentnum;
            
            NSString *sql=[NSString stringWithFormat:@"insert into outactivity values('%@','%@','%@','%@','%@',,'%@'%ld,%ld,%ld);",_id,title,img,cate,deadline,time,pride,oppose,comment];
            
            [dbhelper excuteInfo:sql];
            
        }
 
    }
    
    
    len = [MyActivityArray count];
    
    if(len!=0){
        
        if(len>20){
            
            len=20;
            
        }
        
        [dbhelper excuteInfo:@"delete from myactivity;"];
        
        for(int i=0;i<len;i++){
            
            InActivityBean *bean=[OutActivityArray objectAtIndex:i];
            
            NSString *_id = bean._id;
            NSString *title = bean.title;
            NSString *img = bean.imgurl;
            NSString *cate =bean.category;
            NSString *deadline = [Util stringFromDate:bean.deadline];
            NSString *time = bean.time;
            NSInteger pride = bean.pridenum;
            NSInteger oppose = bean.opposenum;
            NSInteger comment = bean.commentnum;
            
            NSString *sql=[NSString stringWithFormat:@"insert into myactivity values('%@','%@','%@','%@','%@',,'%@'%ld,%ld,%ld);",_id,title,img,cate,deadline,time,pride,oppose,comment];
            
            [dbhelper excuteInfo:sql];
            
        }
        
    }
    
    [dbhelper CloseDB];
    
    extern NSString *LoginDate;
    
    NSString *exitDate=[Util stringFromDate:[[NSDate alloc]init]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    NSString *method=@"logintime";
    NSString *property=[NSString stringWithFormat:@"userid=%@&logintime=%@~%@",userid,LoginDate,exitDate];
    
    [HttpGet DoGet:method property:property];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}



//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    extern Boolean NetLink;
    
    if(status == ReachableViaWWAN)
    {
        
        NetLink=true;
        
        printf("\n3g/2G\n");
        
    }
    else if(status == ReachableViaWiFi)
    {
        NetLink=true;
        
        printf("\nwifi\n");
        
    }else
    {
        NetLink=false;
        printf("\n无网络\n");
    }
    
}

-(void)listenerService:(id)sender{
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    id RegisterFirst=[userDefaults objectForKey:@"RegisterFirst"];
    
    if(RegisterFirst ==nil){
        
        return ;
        
    }
    
    MyListener *listent=[[MyListener alloc]init];
    
    [listent UpdateNotice];
    tag++;
    
    if(tag==10||tag==0){
        
        [listent UpdateTeam];
        tag=1;
        
    }
    
}


@end
