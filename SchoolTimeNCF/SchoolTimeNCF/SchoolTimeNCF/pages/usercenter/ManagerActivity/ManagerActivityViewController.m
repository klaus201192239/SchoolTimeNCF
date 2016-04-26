//
//  ManagerActivityViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ManagerActivityViewController.h"
#import "MyActivityViewController.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "UIView+Toast.h"
#import "MyJson.h"
#import "ManagerActivityListViewController.h"
#import "ChooseOrganizationViewController.h"
#import "ManagerTeacherViewController.h"

@interface ManagerActivityViewController ()

@end

@implementation ManagerActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackButton];
    
    self.navigationItem.title = @"活动管理";//by lil

}

-(IBAction)studentPress:(id)sender{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在验证身份信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        NSInteger tag=0;
        
        NSString *orgnization;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *Phone=[userDefaults stringForKey:@"Phone"];
        NSString *Pwd=[userDefaults stringForKey:@"Pwd"];
        
        
        NSString *method=@"loginweb";
        NSString *property=[NSString stringWithFormat:@"phone=%@&pwd=%@",Phone,Pwd];
        
        NSString *httpJson=[HttpGet DoGet:method property:property];
        
        NSMutableArray *array;
        
        if([httpJson isEqualToString:@"error"]){
            
            tag=0;
            
        }else{

        
            if([httpJson isEqualToString:@"wrong"]){
                
                tag=1;
                
            }else{
                
                if(httpJson.length>=2){
                    
                    if([[httpJson substringWithRange:NSMakeRange(0,2)] isEqualToString:@"ok"]){
                        
                        NSString *ok=[httpJson substringFromIndex:2];
                        
                        array=[MyJson JsonSringToArray:ok];
                        
                        NSInteger len=[array count];
                        
                        
                        if(len==0){
                            
                            tag=1;
                        }
                        if(len==1){

                            NSMutableDictionary *dic=[array objectAtIndex:0];
                            
                            orgnization=[dic objectForKey:@"id"];
                            
                            tag=2;
                        }
                        if(len>1){
                            
                            tag=3;
                        }
                    }
                }
            }

        }
        
        [hud hide:YES];
        
        
        if(tag==0){
            
            [self.view makeToast:@"网络连接或其他意外错误"];
            
        }
        if(tag==1){
            
            [self.view makeToast:@"您没有管理活动的权限，请联系您的组织部门"];

            
        }
        if(tag==2){
            
            [self.view makeToast:@"验证成功，正在跳转请稍后"];
            
            ManagerActivityListViewController *mana=[[ManagerActivityListViewController alloc]init];
            
            mana.oganizationid=orgnization;
            
            [self.navigationController pushViewController:mana animated:YES];

            
            
        }
        if(tag==3){
            
               [self.view makeToast:@"验证成功，正在跳转请稍后"];
            
               ChooseOrganizationViewController *choose=[[ChooseOrganizationViewController alloc]init];
            
                choose.oganization=array;
            
                 [self.navigationController pushViewController:choose animated:YES];

        }
 
    });

}

-(IBAction)teacherPress:(id)sender{
    
    
    ManagerTeacherViewController *teacher=[[ManagerTeacherViewController alloc]init];
    
    [self.navigationController pushViewController:teacher animated:YES];
    
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

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden =YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
