//
//  OnlySignUpViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/15.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "OnlySignUpViewController.h"
#import "SingleInputTableCell.h"
#import "SignUpOnlyBean.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "SingleButtonTableCell.h"
#import "Util.h"
#import "DBHelper.h"
#import "UIView+Toast.h"
#import "InActivityViewController.h"

@interface OnlySignUpViewController (){
    
    NSMutableArray  *tableArray;
    NSString *tableId;
    
}

@end

@implementation OnlySignUpViewController

@synthesize activityid;
@synthesize from;
@synthesize teamtag;
@synthesize teamid;
@synthesize showself;
@synthesize teaminfo;
@synthesize activityName;

@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableArray=[[NSMutableArray alloc]init];
    
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.navigationItem.title = @"报名信息";//by lily
    
    
    [self AddNavigationBack];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在生成报名表,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        [self getNetData];
        
        [hud hide:YES];
        
        [myTableView reloadData];
        
        
    });

    // Do any additional setup after loading the view from its nib.
}

-(void)getNetData{
    
    NSString *method=@"getsignupinfo";
    NSString *property=[NSString stringWithFormat:@"activityid=%@",activityid];
    
    NSString *httpjso=[HttpGet DoGet:method property:property];
    
    if([httpjso isEqualToString:@"error"]){
        
        
    }else{
        NSMutableDictionary *Dictionary=[MyJson JsonSringToDictionary:httpjso];
        
        tableId=[Dictionary objectForKey:@"_id"];
        
        NSArray *array=[Dictionary objectForKey:@"TableInfoColumn"];
        
        
        for(int i=0;i<[array count];i++){
            
            NSDictionary *dic=[array objectAtIndex:i];
            
            SignUpOnlyBean *bean=[[SignUpOnlyBean alloc]init];
            
            bean.cloumnname=[dic objectForKey:@"Name"];
            bean.cloumntext=@"";
            
            [tableArray addObject:bean];
            
        }
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        
        return [tableArray count];
        
    }else{
        
        return 1;
        
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section==0){
        
        static NSString *simpleTableIdentifier = @"SingleInputTableCell";
        
        SingleInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SingleInputTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        cell.input.tag = indexPath.row;
        cell.input.delegate = self;
        
        [cell.input addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
        SignUpOnlyBean *bean=[tableArray objectAtIndex:indexPath.row];
        
        cell.input.placeholder =bean.cloumnname;
        
        return cell;
        
    }else{
        
        static NSString *simpleTableIdentifier = @"SingleButtonTableCell";
        
        SingleButtonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SingleButtonTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.img.userInteractionEnabled=YES;        
        UITapGestureRecognizer *imgTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadInfo:)];
        [cell.img addGestureRecognizer:imgTapGestureRecognizer];
        
        return cell;
        
        
    }

}


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section==0){
        return 44;
    }else{
        return 35;
    }
}



- (void)textFieldWithText:(UITextField *)textField
{
    
    
    SignUpOnlyBean *bean=[tableArray objectAtIndex:textField.tag];
    
    bean.cloumntext=textField.text;
    
    
    [tableArray replaceObjectAtIndex:textField.tag withObject:bean];
    
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

-(void)goBackAction{
    
   // [self.navigationController popViewControllerAnimated:YES];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"取消报名"
                                                  message:@"您确定取消报名信息么？？"
                                                 delegate:self
                                        cancelButtonTitle:@"继续报名"
                                        otherButtonTitles:@"取消报名", nil];
    [alert show];

    

}

-(void)backMain{
    
    
    InActivityViewController *activity=[self.navigationController.viewControllers objectAtIndex:0];
    
    activity.changeTag=0;
    
    [self.navigationController popToViewController:activity animated:TRUE];
    

    
    
}


-(void) uploadInfo:(UITapGestureRecognizer *)recognizer{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *realname=[userDefaults objectForKey:@"Name"];
    NSString *IdCard=[userDefaults objectForKey:@"StudentId"];
    
    
    Boolean ty=false;
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from attendactivity where activityid='%@';",activityid];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        ty = true;
    }
    
    [dbhelper CloseDB];
    
    if(ty==true){
        [self.view makeToast:@"您已经报过名了哦〜〜"];
        return;
    }
    
    for(int i=0;i<[tableArray count];i++){
        
        SignUpOnlyBean *bean=[tableArray objectAtIndex:i];
       
        if (bean.cloumntext.length == 0) {
            [self.view makeToast:@"请填写全部字段信息〜〜"];
            return;
        }
        
        if([bean.cloumnname isEqualToString:@"姓名"]){

            if(![bean.cloumntext isEqualToString:realname]){
                [self.view makeToast:[NSString stringWithFormat:@"姓名输入有误，您的姓名应为%@",realname]];
                return;
            }
        }

        if([bean.cloumnname isEqualToString:@"学号"]){
            
            if(![bean.cloumntext isEqualToString:IdCard]){
                [self.view makeToast:[NSString stringWithFormat:@"学号输入有误，您的学号应为%@",IdCard]];
                return;
            }
        }

        
    }

    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在提交报名信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *result=@"";
        
        if(teamtag==0){
            
            result=[self uploadTag0];
            
        }else{
            if(teamtag==1){
                
                result=[self uploadTag1];
                
                
            }else{
                
                result=[self uploadTag2];
                
            }
        }
        
        if ([result isEqualToString:@"error"]) {
           
            [self.view makeToast:@"报名失败，请检查网络或其他错误〜！"];

            
            //[self.navigationController si
            
            
        } else {
            
            DBHelper *dbhelperr=[[DBHelper alloc]init];
            
            [dbhelperr CreateOrOpen];
            
            [dbhelperr excuteInfo:[NSString stringWithFormat:@"insert into attendactivity values('%@');",activityid]];
            
            [dbhelperr CloseDB];
            
            [self.view makeToast:@"恭喜您，报名成功，祝好运哦！"];
            
            [self backMain];
            
        }
        
        
        [hud hide:YES];
  
    });


}

-(NSString *)uploadTag0{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    NSString *ShoolId=[userDefaults objectForKey:@"ShoolId"];
    NSString *IdCard=[userDefaults objectForKey:@"StudentId"];
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for(int i=0;i<[tableArray count];i++){
        
        SignUpOnlyBean *bean=[tableArray objectAtIndex:i];

        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  
        [dic setValue:[Util encodeString:bean.cloumnname] forKey:@"name"];
        [dic setValue:[Util encodeString:bean.cloumntext] forKey:@"txt"];

        [array addObject:dic];
        
    }
    
    NSString *method=@"attendonly";
    NSString *property=[NSString stringWithFormat:@"tableid=%@&userid=%@&info=%@&schoolid=%@&idcard=%@",tableId,userid,[MyJson ArrayToJsonString:array],ShoolId,IdCard];

    NSString *httpjso=[HttpGet DoPost:method property:property];

    return httpjso;
    
    //NSLog(property);
    //return @"error";
    
}


-(NSString *)uploadTag1{
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *ShoolId=[userDefaults objectForKey:@"ShoolId"];
    NSString *IdCard=[userDefaults objectForKey:@"StudentId"];
    NSString *SName=[Util encodeString:[userDefaults objectForKey:@"Name"]];
    NSString *MajorName=[Util encodeString:[userDefaults objectForKey:@"MajorName"] ];
    NSInteger Degree=[userDefaults integerForKey:@"Degree"];
    NSString *Phone=[userDefaults objectForKey:@"Phone"];
    NSInteger Grade=[userDefaults integerForKey:@"Grade"];
    
    
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for(int i=0;i<[tableArray count];i++){
        
        SignUpOnlyBean *bean=[tableArray objectAtIndex:i];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:[Util encodeString:bean.cloumnname] forKey:@"name"];
        [dic setValue:[Util encodeString:bean.cloumntext] forKey:@"txt"];
        
        [array addObject:dic];
        
    }
    
    NSString *method=@"attendcreateteam";
    NSString *property=[NSString stringWithFormat:@"%@&tableid=%@&info=%@&idcard=%@&sname=%@&smajor=%@&sdegree=%ld&sphone=%@&sgrade=%ld&activityname=%@&schoolid=%@",teaminfo,tableId,[MyJson ArrayToJsonString:array],IdCard,SName,MajorName,Degree,Phone,Grade,[Util encodeString:activityName],ShoolId];

    
    NSString *httpjso=[HttpGet DoPost:method property:property];
    
    return httpjso;
    
    //NSLog(property);
    //return @"error";
    
}


-(NSString *)uploadTag2{
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    NSString *ShoolId=[userDefaults objectForKey:@"ShoolId"];
    NSString *IdCard=[userDefaults objectForKey:@"StudentId"];
    NSString *SName=[Util encodeString:[userDefaults objectForKey:@"Name"]];
    NSString *MajorName=[Util encodeString:[userDefaults objectForKey:@"MajorName"] ];
    NSInteger Degree=[userDefaults integerForKey:@"Degree"];
    NSString *Phone=[userDefaults objectForKey:@"Phone"];
    NSInteger Grade=[userDefaults integerForKey:@"Grade"];
    
    
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for(int i=0;i<[tableArray count];i++){
        
        SignUpOnlyBean *bean=[tableArray objectAtIndex:i];

        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:[Util encodeString:bean.cloumnname] forKey:@"name"];
        [dic setValue:[Util encodeString:bean.cloumntext] forKey:@"txt"];
        
        [array addObject:dic];
        
    }
    
    NSString *method=@"attendotherteam";
    NSString *property=[NSString stringWithFormat:@"tableid=%@&userid=%@&info=%@&teamid=%@&abstra=%@&idcard=%@&sname=%@&smajor=%@&sdegree=%ld&sphone=%@&sgrade=%ld&schoolid=%@",tableId,userid,[MyJson ArrayToJsonString:array],teamid,[Util encodeString:showself],IdCard,[Util encodeString:SName],[Util encodeString:MajorName],Degree,Phone,Grade,ShoolId];
    
    NSString *httpjso=[HttpGet DoPost:method property:property];
    
    return httpjso;
    
   // NSLog(property);
   // return @"error";
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
      //[self.navigationController popViewControllerAnimated:YES];
        
        
        [self backMain];
        
    }
}



@end
