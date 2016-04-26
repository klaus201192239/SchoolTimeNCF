//
//  ExamineTeamViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ExamineTeamViewController.h"
#import "UIView+Toast.h"
#import "DBHelper.h"
#import "TeamMemberBean.h"
#import "Util.h"
#import "ExamineTableViewCell.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"

@interface ExamineTeamViewController (){
    NSMutableArray *memberArray;
    NSInteger type;
    NSInteger buttonflag;
}

@end

@implementation ExamineTeamViewController

@synthesize power;
@synthesize memberTabel;
@synthesize teamid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButton];
    memberTabel.separatorStyle = UITableViewCellSelectionStyleNone;
    
    memberArray=[[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"团队管理";//by lil

    
    extern Boolean NetLink;
    
    if(NetLink==false){
        
        [self.view makeToast:@"网络连接不正常，无法获取最新数据〜"];
        
        return ;
    }
    
    [self intiData];
    if (power==0) {
        [self.existButton setBackgroundImage:[UIImage imageNamed:@"tuichutuan.png"] forState:UIControlStateNormal];
    }else{
        [self.existButton setBackgroundImage:[UIImage imageNamed:@"jiesantuan.png"] forState:UIControlStateNormal];
    }
    
}

-(void)intiData{
    
    //  NSInteger count=0;
    
    //  NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
    //  NSLog(@"count=%ld",count);
    
    if([dbHelper CreateOrOpen]==true){
        
        //   NSLog(@"dataBase open! teamid=%@\npower=%ld ",teamid,power);
        
        FMResultSet *rs=[dbHelper QueryResult:[@"select * from teammember where teamid=" stringByAppendingFormat:@"'%@';",teamid]];
        
        while ([rs next])
        {
            //        NSLog(@"count=%ld",count++);
            
            TeamMemberBean *bean=[[TeamMemberBean alloc]init];
            
            bean.abstracts=[rs stringForColumnIndex:8];
            bean.degree=[rs intForColumnIndex:5];
            bean.grade=[rs intForColumnIndex:6];
            bean.major=[rs stringForColumnIndex:4];
            bean.name=[rs stringForColumnIndex:3];
            bean.phone=[rs stringForColumnIndex:7];
            bean.state=[rs intForColumnIndex:9];
            bean.userid=[rs stringForColumnIndex:1];
            bean.idcard=[rs stringForColumnIndex:2];
            
            
            //     NSLog(@"Memberbean.userid=%@",bean.userid);
            //     NSLog(@"Memberbean.name=%@",bean.name);
            //     NSLog(@"Memberbean.phone=%@",bean.phone);
            //     NSLog(@"Memberbean.power=%ld",bean.degree);
            
            [memberArray addObject:bean];
            
        }
        
        [dbHelper CloseDB];
        
    }
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

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden =YES;
    
}


-(IBAction)exist:(id)sender{
    
    extern Boolean NetLink;
    
    if(NetLink==false){
        
        [self.view makeToast:@"网络连接不正常〜"];
        
        return ;
    }
    if (self.power==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"退出团队"
                                                      message:@"您确定退出该团队么？"
                                                     delegate:self
                                            cancelButtonTitle:@"暂不退出"
                                            otherButtonTitles:@"确定退出", nil];
        [alert setTag:0];
        [alert show];
    }else{
        UIAlertView *alertt=[[UIAlertView alloc]initWithTitle:@"解散团队"
                                                      message:@"您确定解散该团队么？"
                                                     delegate:self
                                            cancelButtonTitle:@"暂不解散"
                                            otherButtonTitles:@"确定解散", nil];
        [alertt setTag:1];
        [alertt show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        if (alertView.tag==0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *stuid=[userDefaults stringForKey:@"Id"];
            NSString *idcard=[userDefaults stringForKey:@"StudentId"];
            NSString *schoolid=[userDefaults stringForKey:@"SchoolId"];
            type=0;
            
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText=@"正在执行操作,请稍候！";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString * httpjson=nil;
                @try {
                    NSString *pro=[[NSString alloc] initWithFormat:@"teamid=%@&userid=%@&type=%ld&schoolid=%@&idcard=%@" ,teamid,stuid,type,schoolid,idcard];
                    NSLog(@"%@",pro);
                    httpjson=[HttpGet DoGet:@"teammanager" property:pro];
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"Exception: %@", exception);
                }
                
                NSLog(@"%@",httpjson);
                
                [hud hide:YES];
                if([httpjson isEqualToString:@"error"]){
                    [self handleMessage:0];
                    
                }else{
                    if([httpjson isEqualToString:@"ok"]){
                        [self handleMessage:2];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [self handleMessage:1];
                    }
                }
               
            });
            
        }else{
            
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText=@"正在执行操作,请稍候！";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString * httpjson=nil;
                @try {
                    
                    NSString *pro=[[NSString alloc] initWithFormat:@"teamid=%@" ,teamid];
                    
                    NSLog(@"%@",pro);
                    httpjson=[HttpGet DoGet:@"quitteam" property:pro];

                }
                @catch (NSException *exception) {
                    NSLog(@"Exception: %@", exception);
                }
                
                NSLog(@"%@",httpjson);
                
                [hud hide:YES];
                if([httpjson isEqualToString:@"error"]){
                    [self handleMessage:0];
                    
                }else{
                    if([httpjson isEqualToString:@"ok"]){
                        [self handleMessage:2];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [self handleMessage:0];  //??????
                    }
                }
                
            });
        }
        
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [memberArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MemberCellIdentifier=@"MemberCellIdentifier";
    ExamineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberCellIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExamineTableViewCell" owner:self options:nil];
        if ([nib count]>0)
        {
            cell =[nib objectAtIndex:0];
        }
        
    }
    
    TeamMemberBean *bean=[memberArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=[@"" stringByAppendingFormat:@"%@(%@-%ld级)",bean.name,[self getDegree:bean.degree],bean.grade];

    if (bean.major.length>15) {
        cell.majorLabel.text=[bean.major substringToIndex:16];
    }else{
        cell.majorLabel.text=bean.major;
    }
    cell.summaryLabel.text=bean.abstracts;
    cell.phoneLabel.text=bean.phone;
    if (power==0) {
        
        cell.receptButton.hidden=YES;
        cell.refuseButton.hidden=YES;
        
        if (bean.state==0){
        cell.checkLabel.text=@"待审核";
        }else{
        cell.checkLabel.text=@"已审核通过";
        }
        
    }else{
        cell.checkLabel.hidden=YES;
        [cell.receptButton addTarget:self action:@selector(agreeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.refuseButton addTarget:self action:@selector(disagreeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (bean.state==1 || buttonflag==1){
            cell.receptButton.hidden=YES;
            cell.refuseButton.hidden=YES;
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)agreeBtClicked:(UIButton *)sender{
    type=1;
    [self click:sender.tag];
}

-(void)disagreeBtClicked:(UIButton *)sender{
    type=0;
    [self click:sender.tag];
}


-(void)click:(NSInteger)t{
    buttonflag=0;
    extern Boolean NetLink;
    
    if(NetLink==false){
        
        [self.view makeToast:@"网络连接不正常〜"];
        
        return ;
    }
    
    NSLog(@"type=%ld\n",type);
    
    TeamMemberBean *bean=[memberArray objectAtIndex:t];
    
    NSLog(@"bean.userid=%@",bean.userid);
    NSLog(@"bean.name=%@",bean.name);
    NSLog(@"bean.phone=%@",bean.idcard);
    NSLog(@"bean.power=%ld",bean.grade);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *schoolid=[userDefaults stringForKey:@"ShoolId"];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在执行操作,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString * httpjson=nil;
        @try {
            NSString *pro=[[NSString alloc] initWithFormat:@"teamid=%@&userid=%@&type=%ld&schoolid=%@&idcard=%@" ,teamid,bean.userid,type,schoolid,bean.idcard];
            
            NSLog(@"%@",pro);
            
            httpjson=[HttpGet DoGet:@"teammanager" property:pro];
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        
         NSLog(@"%@",httpjson);
        
        [hud hide:YES];
        if([httpjson isEqualToString:@"error"]){
            [self handleMessage:0];
            
        }else{
            if([httpjson isEqualToString:@"ok"]){
                [self handleMessage:2];
                buttonflag=1;
            }else{
                [self handleMessage:0];   //??????
            }
        }
        
    });

}


-(void)handleMessage:(NSInteger)flag{
    if (flag == 0) {
        [self.view makeToast:@"网络连接或其他意外错误"];
    }
    if (flag == 1) {
        [self dataChange];
        [self.view makeToast:@"操作成功〜"];
        [memberTabel reloadData];
    }
    if (flag == 2) {
        [self backTeam];
        [self.view makeToast:@"操作成功〜"];
      
        
    }
}


-(void)dataChange{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stuid=[userDefaults stringForKey:@"Id"];
    NSString *idcard=[userDefaults stringForKey:@"StudentId"];

    DBHelper *dbHelper=[[DBHelper alloc]init];
    if([dbHelper CreateOrOpen]==true){
        if (type==0) {
            [dbHelper QueryResult:[@"delete from teammember where teamid=" stringByAppendingFormat:@"'%@' and userid='%@' and idcard='%@';",teamid,stuid,idcard]];
            for (NSInteger i=0; i<[memberArray count]; i++) {
                TeamMemberBean *bean=[memberArray objectAtIndex:i];
                if ([bean.userid isEqualToString:stuid]) {
                    [memberArray removeObjectAtIndex:i];
                }
            }
            
        }else{
            [dbHelper QueryResult:[@"update teammember set state=1 where teamid=" stringByAppendingFormat:@"'%@' and userid='%@' and idcard='%@';",teamid,stuid,idcard]];
            for (NSInteger i=0; i<[memberArray count]; i++) {
                TeamMemberBean *bean=[memberArray objectAtIndex:i];
                if ([bean.userid isEqualToString:stuid]) {
                    bean.state=1;
                    [memberArray replaceObjectAtIndex:i withObject:bean];
                }
            }

        }
        
        [dbHelper CloseDB];
    }
}

-(void) backTeam{
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
    if([dbHelper CreateOrOpen]==true){
        [dbHelper QueryResult:[@"delete from teammember where teamid=" stringByAppendingFormat:@"'%@';",teamid]];
        [dbHelper QueryResult:[@"delete from myteam where id=" stringByAppendingFormat:@"'%@';",teamid]];
        
        [dbHelper CloseDB];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
