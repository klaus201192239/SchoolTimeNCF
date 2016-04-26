//
//  GetPwdBackViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/9.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "GetPwdBackViewController.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "HttpGet.h"
#import "LoginViewController.h"

@interface GetPwdBackViewController ()

@end

@implementation GetPwdBackViewController

@synthesize phone;
@synthesize email;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.title=@"找 回 密 码";
    
    [self AddNavigationBack];
    
    phone.delegate=self;
    email.delegate=self;
    
}


-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];

    //LoginViewController *login=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //[self.navigationController popToViewController:login animated:TRUE];
 
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
    
    [phone resignFirstResponder];
    [email resignFirstResponder];
}

-(IBAction)bt_onclick:(id)sender{
    
    NSString *phoneTxt=phone.text;
    NSString *emailTxt=email.text;
    
    if(phoneTxt.length==0||emailTxt.length==0){
        
        [self.view makeToast:@"请填全信息"];
        
        return ;
        
    }
    
    if([Util isEmailNO:emailTxt]==false){
        
        [self.view makeToast:@"邮箱格式不正确~"];
        
        return ;
        
    }
    
    if([Util isMobileNO:phoneTxt]==false){
        
        [self.view makeToast:@"手机号码格式不对"];
        
        return ;
    }
    
    
    //show the progress and get the user infomation from the server
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在找回密码,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *pro=[[[@"phone=" stringByAppendingString:phoneTxt] stringByAppendingString:@"&email="] stringByAppendingString:emailTxt];
        
        NSString * httpjson=[HttpGet DoGet:@"getpwd" property:pro];
        
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

-(BOOL)textField:( UITextField  *)textField shouldChangeCharactersInRange:( NSRange )range replacementString:(NSString  *)string{
    
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            [self.view makeToast:@"暂时不支持表情输入哦～～"];
            
            return NO;
        }
    }
    
    return YES;
    
}

-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
}

@end
