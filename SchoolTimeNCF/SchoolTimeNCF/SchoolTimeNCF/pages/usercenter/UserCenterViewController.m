//
//  PersonalCenterViewController.m
//  7
//
//  Created by OurEDA on 15/12/10.
//  Copyright (c) 2015年 OurEDA. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserInformationViewController.h"
#import "SuggestionViewController.h"
#import "SystemSettingViewController.h"
#import "NoticeViewController.h"
#import "MyActivityViewController.h"
#import "ManagerActivityViewController.h"
#import "ActivityIntegralViewController.h"
#import "MyTeamsViewController.h"
#import "UserCenterHeader.h"


@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

@synthesize pc_tableView;
@synthesize listname;
@synthesize changeTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"个人中心";//by lil
    
    //CGSize sizeView=self.view.frame.size;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    NSArray *array=[[NSArray alloc] initWithObjects:@"我参加的活动",@"活动积分",@"活动管理",@"我的团队" ,@"提醒通知",@"系统设置",@"用户留言",nil];
    self.listname=array;
    self.pc_tableView.scrollEnabled=NO;
 
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(changeTag==1){
 
        [pc_tableView reloadData];
        
        changeTag=0;
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    if(section==0){
        
        return 1;
        
    }
    else{
    
        return [self.listname count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section==0){
        
        static NSString *CellIndentifier=@"UserCenterHeader";
        
        UserCenterHeader *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIndentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        
        
        cell.name.text= [NSString stringWithFormat:@"%@(%@)",[userDefaultes stringForKey:@"Name"],[self getDegree:[userDefaultes integerForKey:@"Degree"]]];
        
        
       cell.info.text= [NSString stringWithFormat:@"%@ %@ %@级",[userDefaultes stringForKey:@"SchoolName"] ,[userDefaultes stringForKey:@"MajorName"],[userDefaultes stringForKey:@"Grade"]];
        
        cell.img.image=[UIImage imageNamed:@"head_picture.png"];
        
        return cell;
    }
    else{
        
        static NSString *CellIndentifier=@"CenterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        
        NSUInteger row=[indexPath row];
        
        cell.textLabel.text=[listname objectAtIndex:row];
        
        // Configure the cell...
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0){
        
        
        UserInformationViewController * userInformationView=[[UserInformationViewController alloc] init];
        
        userInformationView.From=@"016";
        
        userInformationView.title=@"个人信息";
        
        [self.navigationController pushViewController:userInformationView animated:YES];

        
    }else{
        
        NSInteger row = [indexPath row];
        if (row==0) {
            
            MyActivityViewController *my=[[MyActivityViewController alloc]init];
            
            [self.navigationController pushViewController:my animated:YES];
            
            
        }else if (row==1){
            ActivityIntegralViewController * integralView=[[ActivityIntegralViewController alloc] init];
            integralView.title=@"活动积分";
            [self.navigationController pushViewController:integralView animated:YES];
            
        }else if (row==2){
            
            ManagerActivityViewController * acManageView=[[ManagerActivityViewController alloc] init];
            
            [self.navigationController pushViewController:acManageView animated:YES];
            
            
        }else if (row==3){
            MyTeamsViewController * teamManegeView=[[MyTeamsViewController alloc] init];
            teamManegeView.title=@"团队管理";
            [self.navigationController pushViewController:teamManegeView animated:YES];
        }else if (row==4){
            NoticeViewController * noticeView=[[NoticeViewController alloc] init];
            noticeView.title=@"消息通知";
            [self.navigationController pushViewController:noticeView animated:YES];
        }else
            if (row==5){
                SystemSettingViewController * systemSettingView=[[SystemSettingViewController alloc] init];
                systemSettingView.title=@"系统设置";
                [self.navigationController pushViewController:systemSettingView animated:YES];
            }
            else if (row==6){
                SuggestionViewController * suggestView=[[SuggestionViewController alloc] init];
                suggestView.title=@"用户留言";
                [self.navigationController pushViewController:suggestView animated:YES];
            }
        
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 88;
    }else{
        return 44;
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
