//
//  SetPassWordViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "SetPassWordViewController.h"
#import "HttpGet.h"
#import "Util.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


@interface SetPassWordViewController ()

@end

@implementation SetPassWordViewController

@synthesize oldpwd;
@synthesize newpwd;
@synthesize newpwdR;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButton];
}

-(void) addBackButton{
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 5, 38, 38);
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}


-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)getPWDback:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *messa=[[@"系统将会发送该附件至您的" stringByAppendingString:[userDefaults stringForKey:@"Email"]]stringByAppendingString:@"邮箱中〜"];
    
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"发送附件请求"
                                                   message:messa
                                                  delegate:self
                                         cancelButtonTitle:@"NO"
                                         otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText=@"正在找回密码,请稍候！";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *email=[userDefaultes stringForKey:@"Email"];
            NSString *name=[userDefaultes stringForKey:@"Name"];
            NSString *pwd=[userDefaultes stringForKey:@"Pwd"];
            
            NSString * httpjson=nil;
            @try {
                NSString *pro=[[NSString alloc] initWithFormat:@"name=%@&pwd=%@&email=%@" ,[Util encodeString:name],pwd,email];
                
                httpjson=[HttpGet DoGet:@"getbackpwd" property:pro];
                
                NSLog(@"%@",httpjson);
            }
            @catch (NSException *exception) {
                NSLog(@"Exception: %@", exception);
            }
            
            NSLog(@"%@",httpjson);
            if([httpjson isEqualToString:@"ok"]){
                
                [self.view makeToast:@"密码已经发送到您的邮箱〜请查收"];
                
            }else{
                if([httpjson isEqualToString:@"wrong"]){
                    
                    [self.view makeToast:@"邮箱或电话与注册时信息不一致"];
                    
                }else{
                    
                    [self.view makeToast:@"网络连接错误"];
                }
                
            }
            [hud hide:YES];
        });
    }
    
}


-(IBAction)changePWD:(id)sender{
    extern Boolean NetLink;
    
    if(NetLink==false){
        
        [self.view makeToast:@"网络接连不可用"];
        
        return ;
    }
    if (oldpwd.text==nil || oldpwd.text.length==0) {
        [self.view makeToast:@"请填写原密码"];
        return;
    }
    
    if (newpwd.text==nil || newpwd.text.length==0) {
        [self.view makeToast:@"请填写新密码"];
        return;
    }
    
    if (newpwdR.text==nil || newpwdR.text.length==0) {
        [self.view makeToast:@"请再次填写新密码"];
        return;
    }
    
    if (![newpwdR.text isEqualToString:newpwd.text]) {
        [self.view makeToast:@"两次输入的新密码不一样"];
        return;
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *_id=[userDefaultes stringForKey:@"Id"];
  //  NSString *name=[userDefaultes stringForKey:@"Name"];
    NSString *pwd=[userDefaultes stringForKey:@"Pwd"];
    
    if (![oldpwd.text isEqualToString:pwd]) {
        [self.view makeToast:@"原密码输入有误"];
        return;
    }
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在修改密码,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       
        
        NSString * httpjson=nil;
        NSString *pro=[[NSString alloc] initWithFormat:@"userid=%@&pwd=%@" ,_id,newpwd.text];
         NSLog(@"%@",pro);   
         httpjson=[HttpGet DoGet:@"changepwd" property:pro];
         NSLog(@"%@",httpjson);
        
        if([httpjson isEqualToString:@"ok"]){
            
            [self.view makeToast:@"密码修改成功,请重新登录"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:0 forKey:@"LoginState"];
            
            
            [userDefaults setObject:newpwdR.text forKey:@"Pwd"];
            
            
            [userDefaults synchronize];
            
            
            UINavigationController *navController=[[UINavigationController alloc]init];
            
            LoginViewController *login=[[LoginViewController alloc]init];
            
            [navController pushViewController:login animated:NO];
            
            UIApplication *app =[UIApplication sharedApplication];
            AppDelegate *app2 = app.delegate;
            app2.window.rootViewController = navController;
            
        }else{
                
                [self.view makeToast:@"网络连接或其他意外错误"];
        }
        
        [hud hide:YES];
    });

}


-(IBAction)backgroundTap:(id)sender
{

    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
