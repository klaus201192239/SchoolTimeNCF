//
//  SignInViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/21.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "SignInViewController.h"
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

@interface SignInViewController ()<CLLocationManagerDelegate>{
    
    NSMutableArray *arrayTable;
    double lat;
    double lon;
    NSInteger tagUpdateLocation;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SignInViewController

@synthesize myTableView;

@synthesize activityid;
@synthesize titl;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    lat=0;
    lon=0;
    tagUpdateLocation=0;
    
    self.navigationItem.title = @"报名情况";//by lily
    self.automaticallyAdjustsScrollViewInsets=NO;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self AddNavigationBack];
    
    arrayTable=[[NSMutableArray alloc]init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    
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
    
    if(tagUpdateLocation==1){
        
        [self.locationManager stopUpdatingLocation];
    }
    
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
        
        cell.name.text=titl;
        
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

-(IBAction)qiandao:(id)sender{
    
    [self getLocation];
    
}

- (void)getLocation
{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        tagUpdateLocation=1;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签到环节" message:@"确定开始签到么？" delegate:self cancelButtonTitle:@"暂时不签" otherButtonTitles:@"开始签到", nil];
        alert.tag=1;
        [alert show];
        
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
             [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Request" message:@"To use this feature you need to turn on Location Service." delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Go to Settings", nil];
        alert.tag=2;
        [alert show];
    }
    else {
        
        [self.locationManager startUpdatingLocation];
        tagUpdateLocation=1;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签到环节" message:@"确定开始签到么？" delegate:self cancelButtonTitle:@"暂时不签" otherButtonTitles:@"开始签到", nil];
        alert.tag=1;
        [alert show];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);

    lat=currLocation.coordinate.latitude;
    lon=currLocation.coordinate.longitude;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    NSLog(@"%@", visit);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if(alertView.tag==1){
            
            NSInteger tag=0;
            
            DBHelper *dbhelper=[[DBHelper alloc]init];
            
            [dbhelper CreateOrOpen];
            
            NSString *select=[NSString stringWithFormat:
                              @"select * from signin where activityid='%@';",activityid];
            
            FMResultSet *rs=[dbhelper QueryResult:select];
            
            if([rs next])
            {
                tag=1;
            }
            
            [dbhelper CloseDB];
            
            if(tag==1){
                [self.view makeToast:@"您已经签过到了哦〜"];
                return ;
            }
            
            if(lat==0||lon==0){
                [self.view makeToast:@"定位失败,将自动选择非基于地理位置定位的方式"];
            }
            
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText=@"正在签到,请稍候！";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                
                NSString *method=@"mysignin";
                NSString *property=[NSString stringWithFormat:@"activityid=%@&userid=%@&localx=%f&localy=%f",activityid,[userDefaultes stringForKey:@"Id"],lat,lon];
                
                NSString *httpjson=[HttpGet DoGet:method property:property];
                
                if([httpjson isEqualToString:@"ok"]){
                    
                    
                    [dbhelper CreateOrOpen];
                    
                    NSString *insert=[NSString stringWithFormat:
                                      @"insert into signin values('%@');",activityid];
                    [dbhelper excuteInfo:insert];
                    
                    [dbhelper CloseDB];

                    [self.view makeToast:@"签到成功，刷新列表后可查看〜"];
                    
                }else{
                    
                    if([httpjson isEqualToString:@"wrong"]){
                        
                        [self.view makeToast:@"组织者还未发起签到环节"];
                        
                    }else{
                        
                        if([httpjson isEqualToString:@"long"]){
                            
                            [self.view makeToast:@"您距离发起签到的地点较远，未能成功签到"];
                            
                        }else{
                            
                            if([httpjson isEqualToString:@"timeover"]){
                                
                                [self.view makeToast:@"签到时间已经截止，未能成功签到"];
                                
                            }else{
                                
                                [self.view makeToast:@"签到意外失败，请重试活联系主办方老师"];
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                [hud hide:YES];
                
            });

            
        }else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
    }
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
