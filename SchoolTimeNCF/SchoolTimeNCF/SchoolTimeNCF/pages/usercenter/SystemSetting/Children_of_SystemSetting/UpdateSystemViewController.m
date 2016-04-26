//
//  UpdateSystemViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "UpdateSystemViewController.h"
#import "UIView+Toast.h"
#import "LoadDataViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "HttpGet.h"

@interface UpdateSystemViewController ()

@end

@implementation UpdateSystemViewController

@synthesize nowVersionLabel;
@synthesize eVersionLabel;
@synthesize goodsVersionLabel;
@synthesize nowVersion;
@synthesize eVersion;
@synthesize goodsVersion;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self addBackButton];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    nowVersion= [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    eVersion=[userDefaults stringForKey:@"Version"];
    goodsVersion=[userDefaults stringForKey:@"VersionGood"];
    
    nowVersionLabel.text=nowVersion;
    eVersionLabel.text=eVersion;
    goodsVersionLabel.text=goodsVersion;
    
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


-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}


-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)update:(id)sender{

    if([nowVersion isEqualToString:eVersion]){
        [self.view makeToast:@"亲，当前已经是最新版本了〜"];
        return;
    }
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统升级"
                                                  message:@"欢迎您升级到最新版本〜"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"确定", nil];
    [alert show];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [[UIApplication  sharedApplication] openURL :[ NSURL URLWithString:@"http://114.215.87.133:8080/schoolwater/login/login.jsp"]];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
