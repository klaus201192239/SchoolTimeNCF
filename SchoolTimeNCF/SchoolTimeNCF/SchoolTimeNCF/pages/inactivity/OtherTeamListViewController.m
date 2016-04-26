//
//  OtherTeamListViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/17.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "OtherTeamListViewController.h"
#import "OtherTeamTableViewCell.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#include "MyJson.h"
#import "OtherTeamBean.h"
#import "CreateTeamViewController.h"
#import "JoinTeamViewController.h"
#import "JoinTeamVerifyViewController.h"

@interface OtherTeamListViewController (){
    
    NSMutableArray *arrayTable;
    
}

@end

@implementation OtherTeamListViewController

@synthesize teamTableView;
@synthesize createTeamImg;
@synthesize activityId;
@synthesize activityName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    arrayTable=[[NSMutableArray alloc]init];
    
    [self AddNavigationBack];
    
    teamTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
   
    createTeamImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *imgTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createBt:)];
    [createTeamImg addGestureRecognizer:imgTapGestureRecognizer];
  
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取团队信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        NSString *method=@"getteam";
        NSString *property=[NSString stringWithFormat:@"activityid=%@",activityId];
        
        NSString *httpJson=[HttpGet DoGet:method property:property];
        
        if([httpJson isEqualToString:@"error"]){
            
            
            
        }else{
            
            NSMutableArray *array=[MyJson JsonSringToArray:httpJson];
            
            for(int i=0;i<[array count];i++){
                
                NSDictionary *dic=[array objectAtIndex:i];
                
                OtherTeamBean *bean=[[OtherTeamBean alloc]init];
                
                bean._id=[dic objectForKey:@"_id"];
                bean.leader=[dic objectForKey:@"Leader"];
                bean.name=[dic objectForKey:@"Name"];
                bean.need=[dic objectForKey:@"Need"];
                bean.slogan=[dic objectForKey:@"Slogan"];
                NSNumber *data=[dic objectForKey:@"Password"];
                bean.password=[data integerValue];
                bean.abstractinfo=[dic objectForKey:@"Abstract"];
                
                
                [arrayTable addObject:bean];
                
            }
 
        }
        
        [hud hide:YES];
        
        [teamTableView reloadData];
        
        
    });

    //otherTeamImg.userInteractionEnabled=YES;
    //UITapGestureRecognizer *img1TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherBt:)];
    //[otherTeamImg addGestureRecognizer:img1TapGestureRecognizer];
    
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [arrayTable count];
       
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"OtherTeamTableViewCell";
    
    OtherTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherTeamTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    OtherTeamBean *bean=[arrayTable objectAtIndex:indexPath.row];
    
    cell.name.text=[NSString stringWithFormat:@"团队名称:%@",bean.name];
    cell.slogan.text=[NSString stringWithFormat:@"团队口号:%@",bean.slogan];
    cell.abstract.text=[NSString stringWithFormat:@"团队简介:%@",bean.abstractinfo];
    cell.leader.text=[NSString stringWithFormat:@"队长信息:%@",bean.leader];
    cell.need.text=[NSString stringWithFormat:@"团队需求:%@",bean.need];
    
    if(bean.password==0){
        
        cell.password.hidden=YES;
        
    }
    else{
        cell.password.hidden=NO;
        cell.password.text=@"需要口令验证";
        
    }
    
    
    NSInteger indexImg = ((indexPath.row+1) % 9);
    
    [cell.imgage setImage:[UIImage imageNamed:[NSString stringWithFormat: @"oteam%ld.png",indexImg]]];
    
    
    return cell;
    
}


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
    
    OtherTeamBean *bean =[arrayTable objectAtIndex:indexPath.row];
    
    NSInteger pwd=bean.password;
    
    if(pwd==0){
        
        JoinTeamViewController *join=[[JoinTeamViewController alloc]init];
        
        join.activityId=activityId;
        join.teamid=bean._id;
        join.leader=bean.leader;
        join.name=bean.name;
        
        [self.navigationController pushViewController:join animated:YES];
        
    }
    else{
        
        
        JoinTeamVerifyViewController *join=[[JoinTeamVerifyViewController alloc]init];
        
        join.activityId=activityId;
        join.teamid=bean._id;
        join.leader=bean.leader;
        join.name=bean.name;
        join.password=pwd;
        
        [self.navigationController pushViewController:join animated:YES];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 172;
    
}

-(void)createBt:(UITapGestureRecognizer *)recognizer{
    
    CreateTeamViewController *create=[[CreateTeamViewController alloc]init];
    
    create.activityname=activityName;
    create.activityid=activityId;
    
    [self.navigationController pushViewController:create animated:NO];

    
}

/*-(void)otherBt:(UITapGestureRecognizer *)recognizer{
    
    NSLog(@"other");
    
}*/


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

@end
