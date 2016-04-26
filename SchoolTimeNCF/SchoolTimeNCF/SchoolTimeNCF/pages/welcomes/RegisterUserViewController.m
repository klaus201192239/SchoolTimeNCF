//
//  RegisterUserViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/9.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "HttpGet.h"
#import "RegisterInfoViewController.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController

@synthesize EditPhone;
@synthesize EditPwda;
@synthesize EditPwdb;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"手 机 验 证";
    
    [self AddNavigationBack];
    
    EditPwdb.delegate=self;
    EditPwda.delegate=self;
    EditPhone.delegate=self;
    
}

-(void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGFloat keyboardHeight = 286.0f;
    
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height-keyboardHeight - textField.frame.size.height - 5);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}

-(IBAction)backgroundTap:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [EditPhone resignFirstResponder];
    [EditPwda resignFirstResponder];
    [EditPwdb resignFirstResponder];
    
}

-(IBAction)bt_onclick:(id)sender{
    
    extern Boolean NetLink;
    
    if (NetLink == false) {
        [self.view makeToast:@"网络连接不可用"];
        return;
    }
    
    NSString *Phone = EditPhone.text;
    NSString *Pwda = EditPwda.text;
    NSString *Pwdb = EditPwdb.text;
    
    if (Phone.length == 0 || Pwda.length== 0 || Pwdb.length== 0) {
        
        [self.view makeToast:@"请填全信息"];
     
        return;
    }
    
    if([Util isMobileNO:Phone]==false){
        
        [self.view makeToast:@"手机号码格式不对"];
        
        return ;
    }
    
    
    if([Util isPwdNO:Pwda]==false){
        
        [self.view makeToast:@"密码由英文字母|数字|下划线组成"];
        
        return ;
        
    }
    
    if([Pwda isEqualToString:Pwdb]==false){
        
        [self.view makeToast:@"两次输入密码不一样"];
        
        return ;
    }
    
    if(Pwda.length>12||Pwda.length<6){

        [self.view makeToast:@"密码长度为6〜12位"];

        return;
    }
    
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在验证手机号,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSInteger tag=0;

        NSString *pro=[@"phone=" stringByAppendingString:Phone];
        
        NSString * strTemp=[HttpGet DoGet:@"phoneregister" property:pro];
        
        NSString * httpjson= [strTemp stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        if([httpjson isEqualToString:@"error"]){
            
            [self.view makeToast:@"网络连接或其他意外错误"];
            
        }else{
           
            if([httpjson isEqual:@"OK"]){
                
                [self.view makeToast:@"手机号码可以注册"];
                
                tag=1;
 
            }else{
                
                [self.view makeToast:@"手机号码已经注册过了"];
            }
            
        }
        
        [hud hide:YES];
        
        if(tag==1){
            [self pageJump:Phone Password:Pwda];
        }
        
    });
    
}

-(void)pageJump:(NSString *)phone Password:(NSString *) pwd{
    
    RegisterInfoViewController *info=[[RegisterInfoViewController alloc] init];
    
    info.From=@"02";
    info.Phone=phone;
    info.Pwd=pwd;
    
    [self.navigationController pushViewController:info animated:NO];
    
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

@end
