//
//  JoinTeamVerifyViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "JoinTeamVerifyViewController.h"
#import "JoinTeamViewController.h"
#import "UIView+Toast.h"

@interface JoinTeamVerifyViewController ()

@end

@implementation JoinTeamVerifyViewController

@synthesize activityId;
@synthesize teamid;
@synthesize leader;
@synthesize name;
@synthesize password;


@synthesize nameLabel;
@synthesize leaderLabel;
@synthesize indroduce;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self AddNavigationBack];
    
    indroduce.delegate=self;
    
    nameLabel.text=[NSString stringWithFormat:@"团队：%@",name];
    leaderLabel.text=[NSString stringWithFormat:@"队长：%@",leader];

    
    // Do any additional setup after loading the view from its nib.
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
    
    self.tabBarController.tabBar.hidden = YES;
    
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


-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
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
    
    [indroduce resignFirstResponder];
    
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



-(IBAction)upload:(id)sender{
    
    NSString *input=indroduce.text;
    
    if(input.length==0){
        
        [self.view makeToast:@"请输入验证口令〜〜"];
        
        return;
        
    }
    
    NSString *pwd=[NSString stringWithFormat:@"%ld",password];
    
    if(![pwd isEqualToString:input]){
    
        [self.view makeToast:@"验证口令不正确哦"];
        
        return;
        
    }
    
    JoinTeamViewController *join=[[JoinTeamViewController alloc]init];
    
    join.activityId=activityId;
    join.teamid=teamid;
    join.leader=leader;
    join.name=name;
    
    [self.navigationController pushViewController:join animated:YES];

}



@end
