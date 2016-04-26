//
//  RegisterInfoViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/10.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "RegisterInfoViewController.h"
#import "UIView+Toast.h"
#include <QuartzCore/QuartzCore.h>
#import "TxtTableViewCell.h"
#import "RegisterSchoolViewController.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "LoadDataViewController.h"
#import "AppDelegate.h"

@interface RegisterInfoViewController (){
    
    NSMutableArray *degreeArray;
    
    NSMutableArray *majorArray;
    
    NSMutableArray *gradeArray;
    
    NSMutableArray *tableArray;
    
    NSInteger tagArray;//1--degeree  2--major   3--grade
    
}

@end

@implementation RegisterInfoViewController

@synthesize Phone;
@synthesize Pwd;
@synthesize From;
@synthesize UserRealName;
@synthesize Sex;
@synthesize Degree;
@synthesize Grade;
@synthesize SchoolId;
@synthesize SchoolName;
@synthesize MajorName;
@synthesize Education;
@synthesize Email;
@synthesize StudentId;
@synthesize MajorId;
@synthesize MajorInfo;
@synthesize SchoolImg;


@synthesize realName;
@synthesize manButton;
@synthesize womanButton;
@synthesize schoolButton;
@synthesize degreeButton;
@synthesize studentID;
@synthesize majorButton;
@synthesize gradeButton;
@synthesize EamilEdit;
@synthesize myTableView;
//@synthesize updateButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    

    realName.delegate=self;
    studentID.delegate=self;
    EamilEdit.delegate=self;

    self.title=@"个 人 信 息";
    [self AddNavigationBack];
    
    degreeArray=[NSMutableArray arrayWithObjects:@"专科",@"本科",@"研究生",@"博士生",nil];
    gradeArray=[NSMutableArray arrayWithObjects:@"2006年",@"2007年",@"2008年",@"2009年年",@"2010年",@"2011年",@"2012年",@"2013年",@"2014年",@"2015年",@"2016年",@"2017年",@"2018年",nil];
    majorArray=[NSMutableArray arrayWithObjects:@"请先选择学校",nil];

    
    tableArray=[NSMutableArray arrayWithObjects:@"temp",nil];

    myTableView.hidden=YES;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    tagArray=0;
    
    Sex=0;
    Degree=1;
    Grade=2013;
    
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

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    myTableView.hidden=YES;
    
    if([From isEqualToString:@"02"]){
        
        
        
    }else{
        if([From isEqualToString:@"04"]){
            
            [majorArray removeAllObjects];
 
            for(int i=0;i<[MajorInfo count];i++){
                
                NSDictionary *dic= [MajorInfo objectAtIndex:i];
                
                [majorArray addObject:[dic objectForKey:@"Name"]];
                
                if(i==0){
                    
                    [majorButton setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    
                    
                    MajorName=[dic objectForKey:@"Name"] ;
                    
                    MajorId=[dic objectForKey:@"_id"] ;
                    
                }
                
            }
            
            [schoolButton setTitle:SchoolName forState:UIControlStateNormal];
            

        }else{
            
            if([From isEqualToString:@"00"]){
                
                
                
            }else{
                
                [self.view makeToast:@"软件系统发生意外错误，请重启系统"];
                
            }
            
        }
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
    
    CGFloat keyboardHeight = 316.0f;
    
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
    
    [realName resignFirstResponder];
    [studentID resignFirstResponder];
    [EamilEdit resignFirstResponder];


}

-(IBAction)chooseSchool:(id)sender{
    
    RegisterSchoolViewController *schoolPage=[[RegisterSchoolViewController alloc]init];
    
    schoolPage.From=@"03";
    
    [self.navigationController pushViewController:schoolPage animated:NO];
    
}
-(IBAction)update:(id)sender{

    UserRealName=realName.text;
    if(UserRealName==nil||UserRealName.length==0){
        [self.view makeToast:@"请填写姓名"];
        return ;
    }
    
    StudentId=studentID.text;
    if(StudentId==nil||StudentId.length==0){
        [self.view makeToast:@"请填写学号"];
        return ;
    }
    
    
    Email=EamilEdit.text;
    if(Email==nil||Email.length==0){
        [self.view makeToast:@"请填写电子邮件"];
        return ;
    }
    
    if([Util isRealName:UserRealName]==false){
        [self.view makeToast:@"姓名中只能包含汉字和英文"];
        return ;
    }
    
    if(SchoolId==nil||SchoolId.length==0){
        [self.view makeToast:@"请选择学校"];
        return ;
    }
    
    if([Util isEmailNO:Email]==false){
        [self.view makeToast:@"电子邮件格式错误"];
        return ;
    }
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        NSInteger tag=0;
        
        NSString *para0=[@"phone=" stringByAppendingString:Phone];
        NSString *para1=[@"&pwd=" stringByAppendingString:Pwd];
        NSString *para2=[@"&name=" stringByAppendingString:[Util encodeString:UserRealName]];
        NSString *para3=[@"&sex=" stringByAppendingString:[NSString stringWithFormat:@"%ld",Sex]];
        NSString *para4=[@"&schoolid=" stringByAppendingString:SchoolId];
        NSString *para5=[@"&degree=" stringByAppendingString:[NSString stringWithFormat:@"%ld",Degree]];
        NSString *para6=[@"&studentid=" stringByAppendingString:StudentId];
        NSString *para7=[@"&majorid=" stringByAppendingString:MajorId];
        NSString *para8=[@"&grade=" stringByAppendingString:[NSString stringWithFormat:@"%ld",Grade]];
        NSString *para9=[@"&email=" stringByAppendingString:Email];
        NSString *para10=[@"&majorname=" stringByAppendingString:[Util encodeString:MajorName]];
        
        NSString *parameter=[[[[[[[[[[para0 stringByAppendingString:para1] stringByAppendingString:para2] stringByAppendingString:para3] stringByAppendingString:para4] stringByAppendingString:para5] stringByAppendingString:para6] stringByAppendingString:para7] stringByAppendingString:para8] stringByAppendingString:para9] stringByAppendingString:para10];

        NSString * httpjson=[HttpGet DoGet:@"registerinfo" property:parameter];
        
        if([httpjson isEqualToString:@"error"]){

            tag=0;
            
        }else{
            
            if([httpjson isEqualToString:@"Wrong"]){

                tag=1;
   
            }else{

                NSDictionary *dic=[MyJson JsonSringToDictionary:httpjson];
                NSString *_id=[dic objectForKey:@"_id"];
                
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:_id forKey:@"Id"];
                [userDefaults setObject:Phone forKey:@"Phone"];
                [userDefaults setObject:Pwd forKey:@"Pwd"];
                [userDefaults setObject:UserRealName forKey:@"Name"];
                [userDefaults setInteger:Sex forKey:@"Sex"];
                [userDefaults setObject:SchoolId forKey:@"ShoolId"];
                [userDefaults setObject:SchoolName forKey:@"SchoolName"];
                [userDefaults setObject:SchoolImg forKey:@"SchoolImg"];
                [userDefaults setInteger:Degree forKey:@"Degree"];
                [userDefaults setObject:StudentId forKey:@"StudentId"];
                [userDefaults setObject:MajorId forKey:@"MajorId"];
                [userDefaults setObject:MajorName forKey:@"MajorName"];
                [userDefaults setInteger:Grade forKey:@"Grade"];
                [userDefaults setObject:Email forKey:@"Email"];
                [userDefaults setInteger:1 forKey:@"RegisterFirst"];
                [userDefaults setInteger:1 forKey:@"LoginState"];
                
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                // app版本
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                [userDefaults setObject:app_Version forKey:@"Version"];
                [userDefaults setObject:@"goog is goood !!" forKey:@"VersionGood"];
                
                [userDefaults synchronize];

                
                tag=2;
                
            }
        }
        
        [hud hide:YES];

        if(tag==2){
            
            [self.view makeToast:@"恭喜您 注册成功～"];
            
            LoadDataViewController *load=[[LoadDataViewController alloc]init];
            
            UIApplication *app =[UIApplication sharedApplication];
            AppDelegate *app2 = app.delegate;
            app2.window.rootViewController = load;
            
        }else{
            
            if(tag==1){
                
                [self.view makeToast:@"您的学号或邮箱已被他人使用，请仔细检查"];

                
            }else{
                
                [self.view makeToast:@"网络连接或其他意外错误"];

                
            }
            
        }
       
    });
    
}
-(IBAction)chooseMan:(id)sender{
    Sex=0;
    
    [manButton setImage:[UIImage imageNamed:@"yiqiandao.png"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"weiqiandao.png"] forState:UIControlStateNormal];

    
}
-(IBAction)chooseWoMan:(id)sender{
    Sex=1;
    [manButton setImage:[UIImage imageNamed:@"weiqiandao.png"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"yiqiandao.png"] forState:UIControlStateNormal];
    
}
-(IBAction)chooseDegree:(id)sender{
    
    [tableArray removeAllObjects];
    
    for(int i=0;i<[degreeArray count];i++){
        
        [tableArray addObject:[degreeArray objectAtIndex:i]];
        
    }
    
    [myTableView reloadData];
     
    
    myTableView.hidden=NO;
    
    tagArray=1;
    
}
-(IBAction)chooseMajor:(id)sender{
    
    [tableArray removeAllObjects];
    for(int i=0;i<[majorArray count];i++){
        
        [tableArray addObject:[majorArray objectAtIndex:i]];
        
    }
    
    [myTableView reloadData];
    
    myTableView.hidden=NO;

    
    tagArray=2;
    
}
-(IBAction)chooseGrade:(id)sender{
    [tableArray removeAllObjects];
    for(int i=0;i<[gradeArray count];i++){
        
        [tableArray addObject:[gradeArray objectAtIndex:i]];
        
    }
    
    [myTableView reloadData];
    
    myTableView.hidden=NO;
    
    tagArray=3;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableArray count] ;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TxtTableViewCell";
    
    //SimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    TxtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TxtTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.label.text = [tableArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

//设置列表的每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    
    
    myTableView.hidden=YES;
    
    if(tagArray==1){
        
        Degree= indexPath.row;
        
        [degreeButton setTitle:[degreeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];

        
    }else{
        if(tagArray==2){
            
            
            MajorName=[majorArray objectAtIndex:indexPath.row];

            NSDictionary *dic= [MajorInfo objectAtIndex:indexPath.row];
            MajorId=[dic objectForKey:@"_id"];
            
            [majorButton setTitle:[majorArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];

            
        }else{
            
            if(tagArray==3){
                
                Grade=indexPath.row+2006;
             
                [gradeButton setTitle:[gradeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                
            }
            
        }
        
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

@end
