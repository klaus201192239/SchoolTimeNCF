//
//  UserInformationViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "UserInformationViewController.h"
#import "RegisterSchoolViewController.h"
#import "MBProgressHUD.h"
#import "MyJson.h"
#import "HttpGet.h"
#import "TxtTableViewCell.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "DBHelper.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserCenterViewController.h"

@interface UserInformationViewController (){
    
    NSMutableArray *degreeArray;
    
    NSMutableArray *majorArray;
    
    NSMutableArray *gradeArray;
    
    NSMutableArray *tableArray;
    
    NSInteger tagArray;//1--degeree  2--major   3--grade
    
    Boolean changeTag;
    
}


@end

@implementation UserInformationViewController

@synthesize PhoneEdit;
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


@synthesize UserId;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddNavigationBack];
    
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
   // if ([WXWCommonUtils currentOSVersion] > IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
   // }
    
    realName.delegate=self;
    studentID.delegate=self;
    EamilEdit.delegate=self;
    PhoneEdit.delegate=self;
    
    tagArray=0;
    changeTag=false;
    
    [self initData];
    [self initView];
    
    degreeArray=[NSMutableArray arrayWithObjects:@"专科",@"本科",@"研究生",@"博士生",nil];
    gradeArray=[NSMutableArray arrayWithObjects:@"2006年",@"2007年",@"2008年",@"2009年年",@"2010年",@"2011年",@"2012年",@"2013年",@"2014年",@"2015年",@"2016年",@"2017年",@"2018年",nil];
    majorArray=[NSMutableArray arrayWithObjects:@"请先选择学校",nil];
    
    
    tableArray=[NSMutableArray arrayWithObjects:@"temp",nil];

    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获得专业信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        NSString *method=@"getmajor";
        NSString *property=[@"schoolid=" stringByAppendingString:SchoolId];
        
        NSString *httpJson=[HttpGet DoGet:method property:property];
        
        if([httpJson isEqualToString:@"error"]){
            
            
        }else{
            
            MajorInfo=[MyJson JsonSringToArray:httpJson];
            
            for(int i=0;i<[MajorInfo count];i++){
                
                NSDictionary *dic= [MajorInfo objectAtIndex:i];
                
                [majorArray addObject:[dic objectForKey:@"Name"]];
            
            }
  
        }
        
        [hud hide:YES];
        
        [myTableView reloadData];
        
        
    });

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    myTableView.hidden=YES;
    
    if([From isEqualToString:@"04"]){
        
        [self initView];
        
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

-(void)goBackAction{
    
    //UserCenterViewController *activity=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
   // activity.changeTag=0;
    
   // [self.navigationController popToViewController:activity animated:YES];
    
    
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
    
    [PhoneEdit resignFirstResponder];
    [realName resignFirstResponder];
    [studentID resignFirstResponder];
    [EamilEdit resignFirstResponder];

    myTableView.hidden=YES;
}

-(void)initData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UserId=[userDefaults stringForKey:@"Id"];
    Phone=[userDefaults stringForKey:@"Phone"];
    Pwd=[userDefaults stringForKey:@"Pwd"];
    //From=[userDefaults stringForKey:@""];
    UserRealName=[userDefaults stringForKey:@"Name"];
    Sex=[userDefaults integerForKey:@"Sex"];
    Degree=[userDefaults integerForKey:@"Degree"];
    Grade=[userDefaults integerForKey:@"Grade"];
    SchoolId=[userDefaults stringForKey:@"ShoolId"];
    SchoolName=[userDefaults stringForKey:@"SchoolName"];
    MajorName=[userDefaults stringForKey:@"MajorName"];
    //Education=[userDefaults stringForKey:@""];
    Email=[userDefaults stringForKey:@"Email"];
    StudentId=[userDefaults stringForKey:@"StudentId"];
    MajorId=[userDefaults stringForKey:@"MajorId"];
    //MajorInfo=[userDefaults stringForKey:@""];
    SchoolImg=[userDefaults stringForKey:@"SchoolImg"];
    
    
    
}

-(void)initView{
    
    PhoneEdit.text=Phone;
    realName.text=UserRealName;
    
    if(Sex==0){
        
        //manButton.text=[userDefaults stringForKey:@""];
        //womanButton.text=[userDefaults stringForKey:@""];
        [manButton setImage:[UIImage imageNamed:@"yiqiandao.png"] forState:UIControlStateNormal];
        [womanButton setImage:[UIImage imageNamed:@"weiqiandao.png"] forState:UIControlStateNormal];
        
        
    }else{
        
        [manButton setImage:[UIImage imageNamed:@"weiqiandao.png"] forState:UIControlStateNormal];
        [womanButton setImage:[UIImage imageNamed:@"yiqiandao.png"] forState:UIControlStateNormal];
        
    }
    
    [schoolButton setTitle:SchoolName forState:UIControlStateNormal];
    
    [degreeButton setTitle:[self getDegree:Degree] forState:UIControlStateNormal];
    
    studentID.text=StudentId;
    
    [majorButton setTitle:MajorName forState:UIControlStateNormal];
    
    [gradeButton setTitle:[NSString stringWithFormat:@"%ld年",Grade] forState:UIControlStateNormal];
    
    EamilEdit.text=Email;
    

    
    
}


-(IBAction)chooseSchool:(id)sender{
    
    RegisterSchoolViewController *info=[[RegisterSchoolViewController alloc]init];
    
    info.From=@"017";
    
    info.SchoolImg=SchoolImg;
    info.SchoolName=SchoolName;
    info.SchoolId=SchoolId;

    
    info.UserId=UserId;
    info.Phone=Phone;
    info.Pwd=Pwd;
    info.UserRealName=UserRealName;
    info.Sex=Sex;
    info.Degree=Degree;
    info.Grade=Grade;
    info.Email=Email;
    info.StudentId=StudentId;
    
    [self.navigationController pushViewController:info animated:NO];
    
}
-(IBAction)update:(id)sender{
    
    
    Phone=PhoneEdit.text;
    if(Phone==nil||Phone.length==0){
        [self.view makeToast:@"请填写手机号码"];
        return ;
    }
    
    if([Util isMobileNO:Phone]==false){
        
        [self.view makeToast:@"手机号码格式不对"];
        
        return ;
    }

    
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
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sid=[userDefaults stringForKey:@"ShoolId"];
    
    
    NSString *title=@"";
    NSString *message=@"";
    
    if([sid isEqualToString:SchoolId]){
        
        title=@"修改个人信息";
        message=@"确定修改个人信息么？？";
        
    }else{
        changeTag=true;
        title=@"修改个人信息";
        message=@"您即将修改所在学校，系统将会清除所有之前您与学校相关的数据，请谨慎修改";
    }
    
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"放弃"
                                        otherButtonTitles:@"继续", nil];
    [alert show];
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    else {
        
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText=@"正在上传信息,请稍候！";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            NSInteger tag=0;
            
            NSString *para =[NSString stringWithFormat:@"_id=%@&phone=%@&name=%@&sex=%ld&schoolid=%@&degree=%ld&studentid=%@&majorid=%@&grade=%ld&email=%@&majorname=%@",UserId,Phone,[Util encodeString:UserRealName],Sex,SchoolId,Degree,StudentId,MajorId,Grade,Email,[Util encodeString:MajorName]];
            
            NSString * httpjson=[HttpGet DoGet:@"changeinfo" property:para];
            
            if([httpjson isEqualToString:@"error"]){
                
                tag=0;
                
            }else{
                
                if(httpjson.length>5){
                    
                    if([[httpjson substringWithRange:NSMakeRange(0,5)] isEqualToString:@"wrong"]){
                        
                        tag=[[httpjson substringWithRange:NSMakeRange(5,1)] integerValue];
                        
                    }
                    
                }else{

                    tag=2;
                    
                }
                
            }
            
            
            [hud hide:YES];
            
            
            if(tag==0){
                
                [self.view makeToast:@"网络连接或其他意外错误"];
                
            }else{
                
                if(tag==3){
                    
                    [self.view makeToast:@"修改失败，您输入的电话已被他人注册"];
                    
                }else{
                    
                    if(tag==4){
                        
                        [self.view makeToast:@"修改失败，您输入的邮箱已被他人使用"];
                        
                    }else{
                        
                        if(tag==5){
                            
                            [self.view makeToast:@"修改失败，您输入的学号已被他人使用"];
                            
                        }else{
                            
                            if(tag==2){
                                
                                //[self.view makeToast:@""];
                                
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

                                [userDefaults setObject:Phone forKey:@"Phone"];
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

                                
                                
                                if(changeTag==true){
                                    
                                    [self.view makeToast:@"修改成功哦,请重新登录"];
                                
                                    DBHelper *dbhelper=[[DBHelper alloc]init];
                                    
                                    [dbhelper CreateOrOpen];
                                    [dbhelper excuteInfo:@"delete from attendactivity;"];
                                    [dbhelper excuteInfo:@"delete from myactivity;"];

                                    [userDefaults setInteger:0 forKey:@"LoginState"];

                                    [userDefaults synchronize];
                                    
                                    UINavigationController *navController=[[UINavigationController alloc]init];
                                    
                                    LoginViewController *login=[[LoginViewController alloc]init];
                                    
                                    [navController pushViewController:login animated:NO];
                                    
                                    UIApplication *app =[UIApplication sharedApplication];
                                    AppDelegate *app2 = app.delegate;
                                    app2.window.rootViewController = navController;
                                 
                                }
                                else{
                                    [userDefaults synchronize];
                                    
                                    [self.view makeToast:@"修改成功哦"];
                                    
                                    
                                    UserCenterViewController *activity=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                                    
                                    activity.changeTag=1;
                                    
                                    [self.navigationController popToViewController:activity animated:YES];

                                   // [self.navigationController popViewControllerAnimated:YES];

                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        
        });
        
    }
    
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

    TxtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

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



-(NSString *)getDegree:(NSInteger)degreeId{
    if (degreeId == 0) {
        return @"专科";
    }
    if (degreeId == 1) {
        return @"本科";
    }
    if (degreeId == 2) {
        return @"硕士";
    }
    if (degreeId == 3) {
        return @"博士";
    }
    return @"";
    
}


@end
