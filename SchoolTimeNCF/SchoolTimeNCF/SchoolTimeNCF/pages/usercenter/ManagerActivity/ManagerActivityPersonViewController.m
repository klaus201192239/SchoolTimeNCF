//
//  ManagerActivityPersonViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ManagerActivityPersonViewController.h"
#import "SignInTableCellItem.h"
#import "SignInTableCellHeader.h"
#import "SignInBean.h"
#import "HttpGet.h"
#import "UIView+Toast.h"
#import "MyJson.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import <CoreLocation/CoreLocation.h>
#import "DBHelper.h"
#import "ManagerActivityNoticeViewController.h"

@interface ManagerActivityPersonViewController (){
    NSMutableArray *arrayTable;
}

@end

@implementation ManagerActivityPersonViewController

@synthesize activityid;
@synthesize myTableView;
@synthesize orgnizationid;
@synthesize orgnization;
@synthesize tit;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名情况";//by lily
    self.automaticallyAdjustsScrollViewInsets=NO;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self AddNavigationBack];
    
    arrayTable=[[NSMutableArray alloc]init];
    
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.myTableView.mj_header beginRefreshing];
        
        
        [self RefreshData];
        
        
        [self.myTableView reloadData];
        
        
        [self.myTableView.mj_header endRefreshing];
        
        // 进入刷新状态后会自动调用这个block
    }];
    
    
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.myTableView.mj_footer beginRefreshing];
        
        [self LoadMoreData];
        
        
        [self.myTableView reloadData];
        
        
        [self.myTableView.mj_footer endRefreshing];
        
    }];
    
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        extern Boolean NetLink;
        
        if(NetLink==false){
            
            [self.view makeToast:@"网络连接不可用"];
            
        }else{
            
            [self getNetData];
            
        }
        
        [hud hide:YES];
        
      [myTableView reloadData];
        
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)getNetData{
    
    NSString *methoddd=@"getsigninlist";
    
    NSString *propertyyy=[NSString stringWithFormat:@"activityid=%@&currentstuid=0",activityid];
    
    NSString *httpJson=[HttpGet DoGet:methoddd property:propertyyy];
    
    if([httpJson isEqualToString:@"error"]){
        
        
    }else{
        
        NSMutableArray *arrayB=[MyJson JsonSringToArray:httpJson];
        
        for (int i = 0; i <[arrayB count]; i++) {
            
            NSMutableDictionary *rs=[arrayB objectAtIndex:i];
            
            SignInBean *bean=[[SignInBean alloc]init];
            
            NSNumber *de=[rs objectForKey:@"degree"];
            bean.degree=[de integerValue];
            NSNumber *gr=[rs objectForKey:@"grade"];
            bean.grade=[gr integerValue];
            bean._id=[rs objectForKey:@"id"];
            bean.major=[rs objectForKey:@"major"];
            bean.name=[rs objectForKey:@"name"];
            bean.studentid=[rs objectForKey:@"studentid"];
            NSNumber *st=[rs objectForKey:@"state"];
            bean.state=[st integerValue];
            
            [arrayTable addObject:bean];
  
        }
        
    }
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if(section==0){
        return 1;
    }else{
        return [arrayTable count];
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
        
        static NSString *simpleTableIdentifier = @"SignInTableCellHeader";
        
        SignInTableCellHeader *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SignInTableCellHeader" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.name.text=tit;
        
        return cell;
        
    }else{
        
        static NSString *simpleTableIdentifier = @"SignInTableCellItem";
        
        SignInTableCellItem *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SignInTableCellItem" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        SignInBean *bean=[arrayTable objectAtIndex:indexPath.row];

        
        cell.name.text=[NSString stringWithFormat:@"%@  %@",bean.name,bean.studentid];
        cell.major.text=bean.major;
        [cell.image setImage:[UIImage imageNamed:[self getIcon:bean.state]]];
        
        return cell;
        
    }
    
}


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 83;
    }else{
        return 81;
    }
}


-(void)RefreshData{
    
    [arrayTable removeAllObjects];
    
    [self getNetData];
    
    
}

-(void)LoadMoreData{

    SignInBean *bean=[arrayTable lastObject];
    NSString *stuid=bean.studentid;
    
    
    NSString *method=@"getsigninlist";
    NSString *property=[NSString stringWithFormat:@"activityid=%@&currentstuid=%@",activityid,stuid];
    
    NSString *httpjson=[HttpGet DoGet:method property:property];
    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
        NSMutableArray *arrayB=[MyJson JsonSringToArray:httpjson];
        
        for (int i = 0; i <[arrayB count]; i++) {
            
            NSMutableDictionary *rs=[arrayB objectAtIndex:i];
            
            SignInBean *bean=[[SignInBean alloc]init];
            
            NSNumber *de=[rs objectForKey:@"degree"];
            bean.degree=[de integerValue];
            NSNumber *gr=[rs objectForKey:@"grade"];
            bean.grade=[gr integerValue];
            bean._id=[rs objectForKey:@"id"];
            bean.major=[rs objectForKey:@"major"];
            bean.name=[rs objectForKey:@"name"];
            bean.studentid=[rs objectForKey:@"studentid"];
            NSNumber *st=[rs objectForKey:@"state"];
            bean.state=[st integerValue];
            
            [arrayTable addObject:bean];
            
        }
        
    }
    
    
}

-(IBAction)qunfa:(id)sender{
    
    ManagerActivityNoticeViewController *notice=[[ManagerActivityNoticeViewController alloc]init];
    notice.activityid=activityid;
    notice.tit=tit;
    notice.orgnization=orgnization;
    notice.orgnizationid=orgnizationid;
    [self.navigationController pushViewController:notice animated:YES];
    
}



-(NSString *)getIcon:(NSInteger)state{
    
    if(state==0){
        return @"weiqiandao.png";
    }else{
        return @"yiqiandao.png";
    }
    
    return @"yiqiandao.png";
    
}
@end
