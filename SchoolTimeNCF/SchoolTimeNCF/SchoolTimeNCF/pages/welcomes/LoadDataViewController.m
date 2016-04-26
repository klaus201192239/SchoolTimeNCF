//
//  LoadDataViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "LoadDataViewController.h"
#import "Util.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "OutActivityViewController.h"
#import "InActivityViewController.h"
#import "UserCenterViewController.h"
#import "GuideViewController.h"
#import "DBHelper.h"
#import "InActivityBean.h"
#import "MyJson.h"
#import "HttpGet.h"
#import "LoginViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoadDataViewController ()

@end

@implementation LoadDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [NSThread detachNewThreadSelector:@selector(initView:) toTarget:self withObject:nil];

    
}

-(void)initView:(id)sender{
    
    NSDate *login=[NSDate date];
    
    extern NSString *LoginDate;
    
    LoginDate=[Util stringFromDate:login];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    id RegisterFirst=[userDefaults objectForKey:@"RegisterFirst"];
    
    if(RegisterFirst ==nil){
        
        //start guideView
        
        [self toGuide];
        
        //    [self pageJump];
        
        
        //执行pageJump方法 可以测试TabBar  ；；执行toGuide方法 可以测试引导页
        
    }else{
        
        NSInteger LoginState=[userDefaults integerForKey:@"LoginState"];
        
        if(LoginState==0){
            
            [self toLogin];
            //  [self toGuide];
            
        }else{
            
            extern Boolean NetLink;
            
            if(NetLink==false){
                
                [self getLocalData];
                
                [self.view makeToast:@"您的网络连接不正常〜"];
                
                [self pageJump];
                
            }
            else{
                
                [self getNetData];
                
                //start listenning .such as team info,notice and so
                
                
                [self pageJump];
                
                
            }
            
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLocalData{
    
    //open the dataBase ,and read the data that saved int last exit time
    
    //NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    
    extern NSMutableArray *InActivityArray;
    [InActivityArray removeAllObjects];

    DBHelper *dbHelper=[[DBHelper alloc]init];
    if([dbHelper CreateOrOpen]==true){
        
        FMResultSet *rs=[dbHelper QueryResult:@"select * from inactivity order by id desc;"];
        
        while ([rs next])
        {
            InActivityBean *bean=[[InActivityBean alloc]init];
            
            bean._id=[rs stringForColumnIndex:0];
            bean.title=[rs stringForColumnIndex:1];
            bean.imgurl=[rs stringForColumnIndex:2];
            bean.category=[rs stringForColumnIndex:3];
            bean.deadline=[Util dateFromString:[rs stringForColumnIndex:4]];
            bean.time=[rs stringForColumnIndex:5];
            bean.pridenum=[rs intForColumnIndex:6];
            bean.opposenum=[rs intForColumnIndex:7];
            bean.commentnum=[rs intForColumnIndex:8];
            bean.onlyteam=[rs intForColumnIndex:9];
            
            //[tempArray addObject:bean];
            [InActivityArray addObject:bean];
            
        }
        
        [dbHelper CloseDB];
        
        //StaticArray.InActivityArray=tempArray;
 
    }
    
}

-(void)getNetData{

    //get the _id of the schoool
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *schoolid =[userDefaults stringForKey:@"ShoolId"];
    
    //set the url and get the json from server
    
    NSString *method=@"getinactivity";
       
    NSString *property=[NSString stringWithFormat:@"schoolid=%@&currentid=0",schoolid];
    
    
    NSString *httpjson=[HttpGet DoGet:method property:property];

    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
       // NSMutableArray * tempArray=[[NSMutableArray alloc]init];

       // StaticArray.InActivityArray=[[NSMutableArray alloc]init];

        extern NSMutableArray *InActivityArray;
        
        [InActivityArray removeAllObjects];
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson];

        NSInteger length=[array count];

        for(int i=0;i<length;i++){
            
            NSDictionary *dic=[array objectAtIndex:i];
            
            InActivityBean *bean=[[InActivityBean alloc]init];

            bean._id=[dic objectForKey:@"id"];
            bean.title=[dic objectForKey:@"title"];
            bean.imgurl=[dic objectForKey:@"imgurl"];
            bean.category=[dic objectForKey:@"category"];
            bean.deadline=[Util dateFromString:[dic objectForKey:@"deadline"]
];
            bean.time=[dic objectForKey:@"time"];
            bean.pridenum=[[dic objectForKey:@"pridenum"] integerValue];
            bean.opposenum=[[dic objectForKey:@"opposenum"] integerValue];
            bean.commentnum=[[dic objectForKey:@"commentnum"] integerValue];
            bean.onlyteam=[[dic objectForKey:@"onlyteam"] integerValue];

            //[tempArray addObject:bean];
            
            [InActivityArray addObject:bean];
            
            
          }
        
        //StaticArray.InActivityArray=tempArray;
        
    }
    
}

-(void)pageJump{
    
    //set three NavigationController

    //第一个界面
    OutActivityViewController *outAC=[[OutActivityViewController alloc]init];
    UINavigationController *NavigationOut=[[UINavigationController alloc]initWithRootViewController:outAC];
    UIImage *selectImage1 = [UIImage imageNamed:@"yard_square_selected2"];
    UIImage *unselectImage1 = [UIImage imageNamed:@"yard_square_selected1"];
    selectImage1 = [selectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//声明这张图片用原图（不用渲染）
    unselectImage1 = [unselectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//声明这张图片用原图（不用渲染）
    UITabBarItem *outItem =[[UITabBarItem alloc] initWithTitle:@"校外广场" image:unselectImage1 selectedImage:selectImage1];
    NavigationOut.tabBarItem = outItem;
    
    
    //第二个界面
    InActivityViewController *inAC=[[InActivityViewController alloc]init];
    inAC.changeTag=0;
    UINavigationController *NavigationIn = [[UINavigationController alloc] initWithRootViewController:inAC];
    UIImage *selectImage2 = [UIImage imageNamed:@"action_call2"];
    UIImage *unselectImage2 = [UIImage imageNamed:@"action_call1"];
    selectImage2 = [selectImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//声明这张图片用原图（不用渲染）
    unselectImage2 = [unselectImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//声明这张图片用原图（不用渲染）
    UITabBarItem *inItem = [[UITabBarItem alloc] initWithTitle:@"校内精彩" image:unselectImage2 selectedImage:selectImage2];
    NavigationIn.tabBarItem = inItem;
    
    
    //第三个界面
    UserCenterViewController *userCen = [[UserCenterViewController alloc] init];
    UINavigationController *NavigationUser = [[UINavigationController alloc] initWithRootViewController:userCen];
    UIImage *selectImage3 = [UIImage imageNamed:@"self_selected2"];
    UIImage *unselectImage3 = [UIImage imageNamed:@"self_selected1"];
    selectImage3 = [selectImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//声明这张图片用原图（不用渲染）
    unselectImage3 = [unselectImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//声明这张图片用原图（不用渲染）
    UITabBarItem *centerItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:unselectImage3 selectedImage:selectImage3];
    NavigationUser.tabBarItem = centerItem;
    
    
    NSArray *ncs = @[NavigationOut,NavigationIn,NavigationUser];
    
    //设置文字未选中状态时候的文字颜色  （为了方式使用十六进制的颜色代码，在实现文件头部加入一个宏定义，在使用的地方直接调用即可  将颜色代码中的＃换成0x）
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xC1C1C1), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //设置文字选中状态时候的文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xDEB887),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    
    //set a TabBarController that contains three NavigationController
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    tabBarController.viewControllers = ncs;
    //    tabBarController.viewControllers=@[NavigationOut,NavigationIn,NavigationUser];//original
    
    
    [tabBarController setSelectedIndex:1];
    
    
    //change rootViewController

    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = tabBarController;
    
  
}

-(void)toGuide{
    GuideViewController *guide=[[GuideViewController alloc]init];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = guide;
}

-(void)toLogin{
    
    UINavigationController *navController=[[UINavigationController alloc]init];
    
    LoginViewController *login=[[LoginViewController alloc]init];
    
    [navController pushViewController:login animated:NO];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = navController;
}


@end
