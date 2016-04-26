//
//  NoticeDetailViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/16.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

@synthesize titleLabel;
@synthesize timeLabel;
@synthesize contentLabel;
@synthesize publisherLabel;
@synthesize tit;
@synthesize time;
@synthesize content;
@synthesize publisher;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButton];
    self.title=@"通知详情";
    titleLabel.text=tit;
    timeLabel.text=time;
    contentLabel.text=content;
    publisherLabel.text=publisher;
 //   contentLabel.text=@"20:58:16.675 SchoolTimeNCF[1531:34394] enter!2015-12-29 20:58:16.676 SchoolTimeNCF[1531:34394] 32015-12-29 20:58:16.676 SchoolTimeNCF[1531:34394] 关于系统维护的通知2015-12-29 20:58:16.676 SchoolTimeNCF[1531:34394] 官方2015-12-29 20:58:16.677 SchoolTimeNCF[1531:34394] 22015-12-29 20:58:16.677 SchoolTimeNCF[";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
