//
//  LoginViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "AppDelegate.h"
#import "LoadDataViewController.h"
#import "RegisterUserViewController.h"
#import "GetPwdBackViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize pwdEdit;
@synthesize phoneEdit;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    pwdEdit.delegate = self;
    phoneEdit.delegate=self;
    
 
    
}

-(void) viewDidAppear:(BOOL)animated
{
   
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [phoneEdit resignFirstResponder];
    [pwdEdit resignFirstResponder];
}

-(IBAction)bt_login:(id)sender{
    
    //get the input of user
    
    NSString *phone=phoneEdit.text;
    NSString *pwd=pwdEdit.text;
    
    if(phone.length==0||pwd.length==0){
        
        [self.view makeToast:@"请填全信息"];
        
        return ;
        
    }
    
    if([Util isMobileNO:phone]==false){
        
        [self.view makeToast:@"手机号码格式不对"];
        
        return ;
    }
    
    
    if([Util isPwdNO:pwd]==false){
        
        [self.view makeToast:@"密码由英文字母|数字|下划线组成"];
        
        return ;
        
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    id RegisterFirst=[userDefaults objectForKey:@"RegisterFirst"];
    
    if(RegisterFirst ==nil){
        
        extern Boolean NetLink;
        
        if(NetLink==false){
            
            [self.view makeToast:@"网络接连不可用"];
            
            return ;
        }
        
        //show the progress and get the user infomation from the server
        
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];

        hud.labelText=@"正在登录,请稍候！";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //[HttpGet DoGet:@"https://github.com/jdg/MBProgressHUD/"];
            
            
            NSInteger tag=0;//if tag=1 ,then , the user logins succefully
            
            NSString *pro=[[[@"phone=" stringByAppendingString:phone] stringByAppendingString:@"&pwd="] stringByAppendingString:pwd];
            
            //pro="phone=1389843543&pwd=123456"
            
            NSString * httpjson=[HttpGet DoGet:@"login" property:pro];
            
            
            
           // NSLog(httpjson);
            
            if([httpjson isEqualToString:@"error"]){
                
                [self.view makeToast:@"网络连接或其他意外错误"];
                
            }
            else if([httpjson isEqualToString:@"LoginError"]){
                
                [self.view makeToast:@"用户名或密码错误"];
                
            }else{
                
                NSMutableDictionary *jsonobj=[MyJson JsonSringToDictionary:httpjson];
                
                NSString *_id=[jsonobj objectForKey:@"_id"];
                NSString *name=[jsonobj objectForKey:@"Name"];
                NSNumber *sexNum=[jsonobj objectForKey:@"Sex"];
                NSInteger sex=[sexNum integerValue];
                NSString *shcoolid=[jsonobj objectForKey:@"SchoolId"];
                NSString *schoolname=[jsonobj objectForKey:@"SchoolName"];
                NSNumber *degreeNum=[jsonobj objectForKey:@"Degree"];
                NSInteger degree=[degreeNum integerValue];
                NSString *studentid=[jsonobj objectForKey:@"IdCard"];
                NSString *majorid=[jsonobj objectForKey:@"MajorId"];
                NSString *majorname=[jsonobj objectForKey:@"MajorName"];
                NSNumber *gradeNum=[jsonobj objectForKey:@"Grade"];
                NSInteger grade=[gradeNum integerValue];
                NSString *email=[jsonobj objectForKey:@"Email"];
                NSString *schoolimg=[jsonobj objectForKey:@"SchoolImg"];
                
                [userDefaults setObject:_id forKey:@"Id"];
                [userDefaults setObject:phone forKey:@"Phone"];
                [userDefaults setObject:pwd forKey:@"Pwd"];
                [userDefaults setObject:name forKey:@"Name"];
                [userDefaults setInteger:sex forKey:@"Sex"];
                [userDefaults setObject:shcoolid forKey:@"ShoolId"];
                [userDefaults setObject:schoolname forKey:@"SchoolName"];
                [userDefaults setObject:schoolimg forKey:@"SchoolImg"];
                [userDefaults setInteger:degree forKey:@"Degree"];
                [userDefaults setObject:studentid forKey:@"StudentId"];
                [userDefaults setObject:majorid forKey:@"MajorId"];
                [userDefaults setObject:majorname forKey:@"MajorName"];
                [userDefaults setInteger:grade forKey:@"Grade"];
                [userDefaults setObject:email forKey:@"Email"];
                [userDefaults setInteger:1 forKey:@"RegisterFirst"];
                [userDefaults setInteger:1 forKey:@"LoginState"];
                
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                // app版本
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                [userDefaults setObject:app_Version forKey:@"Version"];
                [userDefaults setObject:@"goog is goood !!" forKey:@"VersionGood"];
                
                [userDefaults synchronize];
  
                tag=1;
            }

            [hud hide:YES];
          
            if(tag==1){
                
                [self pageJump];
  
            }
            
            
        });
        
        
    }else{
        
        
        NSString *phoneLocal=[userDefaults stringForKey:@"Phone"];
        NSString *pwdLocal=[userDefaults stringForKey:@"Pwd"];
        
        if([phone isEqualToString:phoneLocal]==true&&[pwd isEqualToString:pwdLocal]==true){
            
            [userDefaults setInteger:1 forKey:@"LoginState"];
            
            [userDefaults synchronize];
            
            [self pageJump];
            
        }
        else{
            
            [self.view makeToast:@"用户名或密码错误"];
            
        }
        
    }

}
-(IBAction)bt_register:(id)sender{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    id RegisterFirst=[userDefaults objectForKey:@"RegisterFirst"];
    
    if(RegisterFirst ==nil){
        
        RegisterUserViewController *registerUser=[[RegisterUserViewController alloc]init];
        
        [self.navigationController pushViewController:registerUser animated:NO];

        
    }else{
        
        [self.view makeToast:@"该手机已经注册过了～"];
        
    }
    
    //UIApplication *app =[UIApplication sharedApplication];
    //AppDelegate *app2 = app.delegate;
    //app2.window.rootViewController = registerUser;
    
}
-(IBAction)bt_pwd:(id)sender{
    
    GetPwdBackViewController *getpwd=[[GetPwdBackViewController alloc]init];
    
    [self.navigationController pushViewController:getpwd animated:NO];
    
    //UIApplication *app =[UIApplication sharedApplication];
    //AppDelegate *app2 = app.delegate;
    //app2.window.rootViewController = getpwd;
    
}

-(void)pageJump{
    
    LoadDataViewController *load=[[LoadDataViewController alloc]init];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = load;
    
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
