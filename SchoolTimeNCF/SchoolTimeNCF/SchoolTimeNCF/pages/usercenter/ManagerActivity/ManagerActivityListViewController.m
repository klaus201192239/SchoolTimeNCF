//
//  ManagerActivityListViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ManagerActivityListViewController.h"
#import "InActivityBean.h"
#import "MyJson.h"
#import "HttpGet.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "InActivityItemCell.h"
#import "InActivityHeaderCell.h"
#import "ImageDownLoad.h"
#import "MJRefresh.h"
#import "MyActivityCommentViewController.h"
#import "ManagerActivityDetailViewController.h"

@interface ManagerActivityListViewController (){
    
    NSMutableArray *arrayTable;
    
}

@end

@implementation ManagerActivityListViewController

@synthesize oganizationid;
@synthesize activityTableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动管理";//by lil
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    activityTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self addBackButton];
    
    arrayTable=[[NSMutableArray alloc]init];
    
    
    self.activityTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.activityTableView.mj_header beginRefreshing];
        
        
        [self RefreshData];
        
        
        [self.activityTableView reloadData];
        
        
        [self.activityTableView.mj_header endRefreshing];
        
        // 进入刷新状态后会自动调用这个block
    }];
    
    
    
    self.activityTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.activityTableView.mj_footer beginRefreshing];
        
        [self LoadMoreData];
        
        
        [self.activityTableView reloadData];
        
        
        [self.activityTableView.mj_footer endRefreshing];
        
    }];

    
    [self initDataArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)initDataArray{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        extern Boolean NetLink;
        if(NetLink==false){
            
            [self.view makeToast:@"您的网络连接不正常〜"];
            
        }else{
            
            [self getNetData];
            
        }
        
        [hud hide:YES];
        
        [activityTableView reloadData];
 
    });
    
}


-(void)getNetData{
    
    NSString *method=@"getmanagelist";
    
    NSString *property=[NSString stringWithFormat:@"oganizationid=%@&currentid=0",oganizationid];
    
    NSString *httpjson=[HttpGet DoGet:method property:property];
    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson];
        
        NSInteger length=[array count];
        
        for(int i=0;i<length;i++){
            
            NSDictionary *dic=[array objectAtIndex:i];
            
            InActivityBean *bean=[[InActivityBean alloc]init];
            
            bean._id=[dic objectForKey:@"id"];
            bean.title=[dic objectForKey:@"title"];
            bean.imgurl=[dic objectForKey:@"imgurl"];
            bean.category=[dic objectForKey:@"category"];
            bean.deadline=[Util dateFromString:[dic objectForKey:@"deadline"]
                           ];
            bean.time=[dic objectForKey:@"time"];
            bean.pridenum=[[dic objectForKey:@"pridenum"] integerValue];
            bean.opposenum=[[dic objectForKey:@"opposenum"] integerValue];
            bean.commentnum=[[dic objectForKey:@"commentnum"] integerValue];

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
        
        static NSString *simpleTableIdentifier = @"InActivityHeaderCell";
        
        InActivityHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        if(cell == nil){
            
            //cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityHeaderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *schoolImg=[userDefaults objectForKey:@"SchoolImg"];
        
        [ImageDownLoad setImageDownLoad:cell.imageView Url:schoolImg];
        
        return cell;
        
    }else{
        static NSString *simpleTableIdentifier = @"InActivityItemCell";
        
        InActivityItemCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        InActivityBean *bean=[arrayTable objectAtIndex:indexPath.row];
        
        cell.title.text=bean.title;
        [ImageDownLoad setImageDownLoad:cell.imgage Url:bean.imgurl];
        cell.categery.text=bean.category;
        
        NSDate *nowDate=[[NSDate alloc]init];
        
        if([nowDate compare:bean.deadline]==NSOrderedDescending){
            
            if([self getYear:bean.deadline]==1900){
                cell.deadline.text=@"";
            }else{
                [cell.deadline setTextColor:[UIColor redColor]];

                cell.deadline.text=[NSString stringWithFormat:@"报名截止:%@%@",[Util stringFromDate:bean.deadline],@"(已经截止)"];
                
            }

            
        }else{
            
            [cell.deadline setTextColor:[UIColor yellowColor]];

            cell.deadline.text=[NSString stringWithFormat:@"报名截止:%@",[Util stringFromDate:bean.deadline]];
            
        }
        
        
        NSRange range = [bean.time rangeOfString:@"~"];
        NSString *startTime = [bean.time substringToIndex:range.location];//开始截取
        NSString *endTime = [bean.time substringFromIndex:range.location+1];//开始截
        
        NSDate *runTime=[Util dateFromString:startTime];
        
        if([self getYear:runTime]==1900){
            
            cell.time.text=@"";
        }else{

            cell.time.text=[NSString stringWithFormat:@"活动时间:%@~%@",[Util stringFromDate:[Util dateFromString:startTime]],[Util stringFromDate:[Util dateFromString:endTime]]];
            
        }
        
        [cell.dislike_num setTextColor:[UIColor redColor]];
        [cell.like_num setTextColor:[UIColor blueColor]];

        cell.dislike_num.text=[NSString stringWithFormat:@"支持 %ld",bean.opposenum];
        cell.like_num.text=[NSString stringWithFormat:@"反对 %ld",bean.pridenum];
        cell.comment_num.text=[NSString stringWithFormat:@"%ld",bean.commentnum];
        cell.sum_num.text=[self getSum:bean.pridenum oppose:bean.opposenum comment:bean.commentnum];
 
        
        cell.title.tag=indexPath.row;
        cell.imgage.tag=indexPath.row;
        
        cell.title.userInteractionEnabled=YES;
        cell.imgage.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *imgTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMore:)];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMore:)];
        
        //[cell.title addGestureRecognizer:labelTapGestureRecognizer];
        [cell.imgage addGestureRecognizer:imgTapGestureRecognizer];
        [cell.title addGestureRecognizer:labelTapGestureRecognizer];
        
        
        cell.likeBt.hidden=YES;
        
        cell.attendBt.hidden=YES;
        
        cell.dislikeBt.hidden=YES;
        
        
        cell.commentBt.tag=indexPath.row;
        [cell.commentBt addTarget:self action:@selector(commentBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    
    
}


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 105;
    }else{
        return 348;
    }
}

-(void)RefreshData{
    
    [arrayTable removeAllObjects];
    
    [self getNetData];
    
    
}

-(void)LoadMoreData{
    
    
    InActivityBean *bean=[arrayTable lastObject];
    
    NSString *_id=bean._id;
    
    NSString *method=@"getmanagelist";
    
    NSString *property=[NSString stringWithFormat:@"oganizationid=%@&currentid=%@",oganizationid,_id];
    
    NSString *httpjson=[HttpGet DoGet:method property:property];
    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson];
        
        NSInteger length=[array count];
        
        for(int i=0;i<length;i++){
            
            NSDictionary *dic=[array objectAtIndex:i];
            
            InActivityBean *bean=[[InActivityBean alloc]init];
            
            bean._id=[dic objectForKey:@"id"];
            bean.title=[dic objectForKey:@"title"];
            bean.imgurl=[dic objectForKey:@"imgurl"];
            bean.category=[dic objectForKey:@"category"];
            bean.deadline=[Util dateFromString:[dic objectForKey:@"deadline"]
                           ];
            bean.time=[dic objectForKey:@"time"];
            bean.pridenum=[[dic objectForKey:@"pridenum"] integerValue];
            bean.opposenum=[[dic objectForKey:@"opposenum"] integerValue];
            bean.commentnum=[[dic objectForKey:@"commentnum"] integerValue];
            
            [arrayTable addObject:bean];
            
        }
        
    }

    
}


- (void)commentBtClicked:(UIButton *)sender{
    
    MyActivityCommentViewController *detail=[[MyActivityCommentViewController alloc]init];
    
    InActivityBean *bean=[arrayTable objectAtIndex:sender.tag];
    
    detail.activityid=bean._id;
    detail.from=@"024";
    detail.titl=bean.title;
    detail.imgurl=bean.imgurl;
    detail.category=bean.category;
    detail.deadline=bean.deadline;
    detail.time=bean.time;
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
}



-(void) showMore:(UITapGestureRecognizer *)recognizer{
    
    
    
    ManagerActivityDetailViewController *detail=[[ManagerActivityDetailViewController alloc]init];
    
    InActivityBean *bean=[arrayTable objectAtIndex:recognizer.view.tag];
    
    detail.activityid=bean._id;
    detail.from=@"024";
    detail.titl=bean.title;
    detail.imgurl=bean.imgurl;
    detail.category=bean.category;
    detail.deadline=bean.deadline;
    detail.time=bean.time;
    detail.opposenum=bean.opposenum;
    detail.pridenum=bean.pridenum;
    detail.commentnum=bean.commentnum;
    detail.orgnizationid=oganizationid;
    
    
    [self.navigationController pushViewController:detail animated:YES];
 
    
}


-(NSString *)getSum:(NSInteger)prideNum oppose:(NSInteger)opposeNum comment:(NSInteger)commentNum{
    
    double t1 = prideNum + 0.0 + commentNum * 2+ opposeNum, t = 0.0;
    if (t1 != 0) {
        t = ((prideNum + 0.0 + commentNum * 2 - opposeNum) * 10)/ t1;
    }
    
    return [NSString stringWithFormat:@"受欢迎程度:%.2f",t];
    
    //return [@"受欢迎程度:" stringByAppendingString:[NSString stringWithFormat:@"%.2f",t]];
}

-(long)getYear:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear;
    comps = [calendar components:unitFlags fromDate:date];
    long year=[comps year];//获取年对应的长整形字符串
    return year;
    
}

@end
