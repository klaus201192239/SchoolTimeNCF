//
//  SuggestionViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "SuggestionViewController.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController

@synthesize sugTextView;
@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButton];
    
    sugTextView.layer.borderColor= UIColor.grayColor.CGColor;
    sugTextView.layer.borderWidth = 1;
    sugTextView.delegate= self;
    
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


-(IBAction)submit:(id)sender{
    NSString *suggestion=sugTextView.text;
    
    if (suggestion==nil || suggestion.length==0) {
        [self.view makeToast:@"请输入意见"];
        return;
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在上传，请稍候！";
    
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, 0.01*NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSInteger tag=0;
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *_id=[userDefaultes stringForKey:@"Id"];
        NSString * httpjson=nil;
        
        @try {
            
            NSLog(@"%@",_id);
            NSString *pro=[[NSString alloc]initWithFormat:@"userid=%@&content=%@" ,_id,[Util encodeString:suggestion]];
            
            NSLog(@"%@",pro);
            
            httpjson=[HttpGet DoGet:@"submitsuggestion" property:pro];
            
            NSLog(@"%@",httpjson);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        
        if ([httpjson isEqual:@"ok"]) {
            tag=1;
        }
        
        if (tag==1) {
            [hud hide:YES];
            [self.view makeToast:@"提交成功，感谢您的宝贵意见~我们互及时与您联系"];
            sugTextView.text=@"";
            
        }else{
            [hud hide:YES];
            [self.view makeToast:@"网络连接或其他意外错误,请重新提交奥"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backgroundTap:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
    [self.view endEditing:YES];
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
