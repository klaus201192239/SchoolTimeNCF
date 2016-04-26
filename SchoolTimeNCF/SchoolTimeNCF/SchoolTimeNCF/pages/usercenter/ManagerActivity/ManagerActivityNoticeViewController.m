//
//  ManagerActivityNoticeViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ManagerActivityNoticeViewController.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"

@interface ManagerActivityNoticeViewController ()

@end

@implementation ManagerActivityNoticeViewController

@synthesize activityid;
@synthesize orgnizationid;
@synthesize orgnization;
@synthesize tit;
@synthesize titleLabel;
@synthesize titleText;
@synthesize contectText;
@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"群发通知";
    titleLabel.text=tit;
    [self addBackButton];
    
    contectText.layer.borderColor= UIColor.grayColor.CGColor;
    contectText.layer.borderWidth = 1;
    contectText.delegate= self;
    
    titleText.delegate=self;
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


-(IBAction)finish:(id)sender{
    NSString *noticetitle=titleText.text;
    NSString *noticecontent=contectText.text;
    
    if (noticetitle==nil || noticetitle.length==0) {
        [self.view makeToast:@"请填写通知标题"];
        return;
    }
    if (noticetitle.length>12) {
        [self.view makeToast:@"通知标题太长了〜"];
        return;
    }
    if (noticecontent==nil || noticecontent.length==0) {
        [self.view makeToast:@"请填写通知内容"];
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在群发消息,请稍候！";
    
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, 0.01*NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        NSString * httpjson=nil;
        
        @try {

            NSString *pro=[[NSString alloc]initWithFormat:@"activityid=%@&oganizationid=%@&oganization=%@&title=%@&content=%@" ,activityid,orgnizationid,[Util encodeString:orgnization],[Util encodeString:noticetitle],[Util encodeString:noticecontent]];
            
            NSLog(@"%@",pro);
            
            httpjson=[HttpGet DoGet:@"managernotice" property:pro];
            
            NSLog(@"%@",httpjson);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        
        if ([httpjson isEqual:@"ok"]) {
            
            [hud hide:YES];
            [self.view makeToast:@"发送成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [hud hide:YES];
            [self.view makeToast:@"网络连接或其他意外错误"];
        }
        
    });
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }
}

-(IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:( UITextField  *)textField shouldChangeCharactersInRange:( NSRange )range replacementString:(NSString  *)string{
    
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            [self.view makeToast:@"暂时不支持表情输入哦～～"];
            
            return NO;
        }
    }
    
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
        // 不让输入表情
        if ([textView isFirstResponder]) {
                if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
                        return NO;
                    }
            }
     
         return YES;
 }

@end
