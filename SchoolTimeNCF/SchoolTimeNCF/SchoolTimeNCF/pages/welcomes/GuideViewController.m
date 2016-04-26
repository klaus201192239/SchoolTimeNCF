//
//  GuideViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "UIView+Toast.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

NSInteger tag;

- (void)viewDidLoad {
    [super viewDidLoad];

    tag=0;
    
    [self showGuide];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGuide
 {
    //set a scrollVioew
     
     CGRect rect = [[UIScreen mainScreen] bounds];
     CGSize size = rect.size;
     CGFloat width = size.width;
     CGFloat height = size.height;
     
//     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];

     [scrollView setContentSize:CGSizeMake(3*width, 0)];
     [scrollView setPagingEnabled:YES];  //视图整页显示
     [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
     
//     scrollView.backgroundColor = [UIColor redColor];
     
     //set three imageView
     
     UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
     [imageview1 setImage:[UIImage imageNamed:@"guide1.jpg"]];
     [scrollView addSubview:imageview1];
     
     UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
     [imageview2 setImage:[UIImage imageNamed:@"guide2.jpg"]];
     [scrollView addSubview:imageview2];

     UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*width, 0, width, height)];
     [imageview3 setImage:[UIImage imageNamed:@"guide3.jpg"]];
     imageview3.userInteractionEnabled = YES;//打开imageview3的用户交互;否则下面的button无法响应
     [scrollView addSubview:imageview3];
     
     //在imageview3上加载一个透明的button
     
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];     [button setTitle:nil forState:UIControlStateNormal];
     [button setFrame:CGRectMake(0, 360, 320, 320)];
     
     //goloLogin when onclick the button
     
     [button addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
     [imageview3 addSubview:button];
     
     // Add the scrollView upto the current view
     
     [self.view addSubview:scrollView];
     [NSThread detachNewThreadSelector:@selector(createDatabase) toTarget:self withObject:nil];
   
}
-(void)gotoLogin{
    
    // user finish the guidePage ,then change the rootViewController to the Login page
    
    if(tag==1){
        UINavigationController *Navigation=[[UINavigationController alloc]init];
        
        LoginViewController *userCen=[[LoginViewController alloc]init];
        
        [Navigation pushViewController:userCen animated:NO];
        
        
        UIApplication *app =[UIApplication sharedApplication];
        AppDelegate *app2 = app.delegate;
        app2.window.rootViewController = Navigation;
        
    }else{
        [self.view makeToast:@"正在配置软件信息，请稍后哦～ "];
    }

}


-(void)createDatabase{
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    if([dbhelper CreateOrOpen]==true){

        [dbhelper excuteInfo:@"drop table inactivity;"];
        [dbhelper excuteInfo:@"drop table takepart;"];
        [dbhelper excuteInfo:@"drop table attendactivity;"];
        [dbhelper excuteInfo:@"drop table outactivity;"];
        [dbhelper excuteInfo:@"drop table takepartout;"];
        [dbhelper excuteInfo:@"drop table myactivity;"];
        [dbhelper excuteInfo:@"drop table myteam;"];
        [dbhelper excuteInfo:@"drop table teammember;"];
        [dbhelper excuteInfo:@"drop table notice;"];
        [dbhelper excuteInfo:@"drop table signin;"];

        
        [dbhelper excuteInfo:@"create table inactivity(id text,title text,imgurl text,category text,deadline text,time text,pridenum int,opposenum int,commentnum int,onlyteam int);"];
        [dbhelper excuteInfo:@"create table takepart(activityid text,type int);"];
        [dbhelper excuteInfo:@"create table attendactivity(activityid text);"];
        [dbhelper excuteInfo:@"create table outactivity(id text,title text,imgurl text,category text,deadline text,time text,pridenum int,opposenum int,commentnum int);"];
        [dbhelper excuteInfo:@"create table takepartout(activityid text,type int);"];
        [dbhelper excuteInfo:@"create table myactivity(id text,title text,imgurl text,category text,deadline text,time text,pridenum int,opposenum int,commentnum int);"];
        [dbhelper excuteInfo:@"create table myteam(id text,name text,leaderid text,idcard text,leadername text,activityname text);"];
        [dbhelper excuteInfo:@"create table teammember(teamid text,userid text,idcard text,name text,major text,degree int,grade int,phone text,abstract text,state int);"];
        [dbhelper excuteInfo:@"create table notice(id INTEGER PRIMARY KEY,title text,publisher text,content text,time text,cid text,type int);"];
        [dbhelper excuteInfo:@"create table signin(activityid text);"];
        
        [dbhelper CloseDB];
        
        tag=1;
        
    }else{
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }

}

@end
