//
//  CreateTeamViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "CreateTeamViewController.h"
#import "UIView+Toast.h"
#import "OnlySignUpViewController.h"
#import "Util.h"

@interface CreateTeamViewController (){
    
    Boolean choosePwd;
    
    NSString *userName;
    
}

@end

@implementation CreateTeamViewController

@synthesize activityid;
@synthesize activityname;
@synthesize from;
@synthesize otherTeamImg;

@synthesize name;
@synthesize slogan;
@synthesize Abstract;
@synthesize need;
@synthesize Password;
@synthesize leader;
@synthesize choose;
@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddNavigationBack];
    
    choosePwd=true;
    
    name.delegate=self;
    slogan.delegate=self;
    Abstract.delegate=self;
    need.delegate=self;
    Password.delegate=self;
    
    otherTeamImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *imgTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherBt:)];
    [otherTeamImg addGestureRecognizer:imgTapGestureRecognizer];
    
    choose.userInteractionEnabled=YES;
    UITapGestureRecognizer *chooseTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseBt:)];
    [choose addGestureRecognizer:chooseTapGestureRecognizer];

    
    if(choosePwd==true){
        
        Password.hidden=YES;
        label.hidden=YES;
        
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    userName=[userDefaults objectForKey:@"Name"];

    leader.text=userName;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    CGFloat keyboardHeight = 310.0f;
    
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height-keyboardHeight - textField.frame.size.height - 5);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
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

-(IBAction)backgroundTap:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [name resignFirstResponder];
    [slogan resignFirstResponder];
    [Abstract resignFirstResponder];
    [need resignFirstResponder];
    [Password resignFirstResponder];
   
}

-(void)otherBt:(UITapGestureRecognizer *)recognizer{
 
    [self.navigationController popViewControllerAnimated:YES];

 
}
-(void)chooseBt:(UITapGestureRecognizer *)recognizer{
    
    if(choosePwd==true){
        
        UIImage *img = [UIImage imageNamed:@"action_call2"];
        [choose setImage:img];
        
        Password.hidden=NO;
        label.hidden=NO;
        
        choosePwd=false;
        
    }else{
        
        UIImage *img = [UIImage imageNamed:@"action_call1"];
        [choose setImage:img];
        
        Password.hidden=YES;
        label.hidden=YES;
        
        choosePwd=true;
        
    }
    
}

-(IBAction)upload:(id)sender{
    
    NSString *nameTxt=name.text;
    NSString *sloganTxt=slogan.text;
    NSString *AbstractTxt=Abstract.text;
    NSString *needTxt=need.text;
    NSString *PasswordTxt=@"0";
    
    if(choosePwd==false){
        
        NSString *pwdTxt=Password.text;
        
        if(pwdTxt.length==0){
            [self.view makeToast:@"请填写全部信息"];
            return ;
        }
        if(pwdTxt.length!=4){
            [self.view makeToast:@"请设置四位整数的验证口令"];
            return ;
        }
        
        PasswordTxt=pwdTxt;
        
    }
    
    if(nameTxt.length==0||sloganTxt.length==0||AbstractTxt.length==0||needTxt.length==0){
        [self.view makeToast:@"请填写全部信息"];
        return ;
    }
    
    if(nameTxt.length>10){
        [self.view makeToast:@"团队名称太长了〜"];
        return ;
    }
    if(sloganTxt.length>12){
        [self.view makeToast:@"团队口号不超过12个字符〜"];
        return ;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    
    NSString *uploadteaminfo=[NSString stringWithFormat:@"userid=%@&activityid=%@&name=%@&slogan=%@&abstract=%@&need=%@&password=%@",userid,activityid,[Util encodeString:nameTxt],[Util encodeString:sloganTxt],[Util encodeString:AbstractTxt],[Util encodeString:needTxt],PasswordTxt];
    
    OnlySignUpViewController *only=[[OnlySignUpViewController alloc]init];
    only.activityid=activityid;
    only.teaminfo=uploadteaminfo;
    only.teamtag=1;
    only.activityName=activityname;
    
    [self.navigationController pushViewController:only animated:NO];
    
}

@end
