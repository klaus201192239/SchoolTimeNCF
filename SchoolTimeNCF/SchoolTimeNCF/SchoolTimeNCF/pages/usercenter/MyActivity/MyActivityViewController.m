//
//  MyActivityViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "MyActivityViewController.h"
#import "DBHelper.h"
#import "InActivityBean.h"
#import "Util.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "InActivityHeaderCell.h"
#import "InActivityItemCell.h"
#import "ImageDownLoad.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "MJRefresh.h"
#import "ActivityJugeBean.h"
#import "MyActivityCommentViewController.h"
#import "MyActivityDetailViewController.h"



@interface MyActivityViewController (){
    
    NSMutableArray *ActivityArray;
    
}

@end

@implementation MyActivityViewController

@synthesize activityTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addBackButton];
    
    self.navigationItem.title = @"我的活动";//by lily
    self.automaticallyAdjustsScrollViewInsets=NO;
    activityTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    ActivityArray=[[NSMutableArray alloc]init];
    
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

    
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        extern Boolean NetLink;
        
        if(NetLink==false){
            
            [self initArrayWithLocal];
            [self.view makeToast:@"网络连接不可用"];
            
        }else{
            
            [self initArrayWithNet];
            
        }

        [hud hide:YES];
        
        [activityTableView reloadData];
        
        
    });

    
}


-(void)initArrayWithLocal{
    
    //extern NSMutableArray *MyActivityArray;
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
    if([dbHelper CreateOrOpen]==true){
        
        FMResultSet *rs=[dbHelper QueryResult:@"select * from myactivity order by id desc;"];
        
        while ([rs next])
        {
            InActivityBean *bean=[[InActivityBean alloc]init];
            
            bean._id=[rs stringForColumnIndex:0];
            bean.title=[rs stringForColumnIndex:1];
            bean.imgurl=[rs stringForColumnIndex:2];
            bean.category=[rs stringForColumnIndex:3];
            bean.deadline=[Util dateFromString:[rs stringForColumnIndex:4]];
            bean.time=[rs stringForColumnIndex:5];
            bean.pridenum=[rs intForColumnIndex:6];
            bean.opposenum=[rs intForColumnIndex:7];
            bean.commentnum=[rs intForColumnIndex:8];

            [ActivityArray addObject:bean];
            
        }
        
        [dbHelper CloseDB];
  
    }
    
}

-(void)initArrayWithNet{
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    
    //extern NSMutableArray *MyActivityArray;
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
    if([dbHelper CreateOrOpen]==true){
        
        FMResultSet *rs=[dbHelper QueryResult:@"select DISTINCT * from attendactivity order by activityid desc limit 3;"];

        
        while ([rs next])
        {
            [tempArray addObject:[rs stringForColumnIndex:0]];
            
        }
        
        [dbHelper CloseDB];
        
    }

    if([tempArray count]==0){

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *UserId=[userDefaults stringForKey:@"Id"];
        NSString *SchoolId=[userDefaults stringForKey:@"ShoolId"];
        NSString *StudentId=[userDefaults stringForKey:@"StudentId"];
        
        
        NSString *method=@"getmyactivityid";
        NSString *property=[NSString stringWithFormat:@"userid=%@&stuid=%@&schoolid=%@",UserId,StudentId,SchoolId];
        
        NSString *httpJson=[HttpGet DoGet:method property:property];
        
        if([httpJson isEqualToString:@"error"]){

            
        }else{
            
            [dbHelper CreateOrOpen];
            
            NSMutableArray *jsonArray=[MyJson JsonSringToArray:httpJson];
            
            for(int i=0;i<[jsonArray count];i++){
                
                NSString *str=[jsonArray objectAtIndex:i];
                
                [dbHelper excuteInfo:[NSString stringWithFormat:@"insert into attendactivity values('%@');",str]];
   
            }

            
            FMResultSet *rs=[dbHelper QueryResult:@"select DISTINCT * from attendactivity order by activityid desc limit 3;"];

            
            while ([rs next])
            {

                [tempArray addObject:[rs stringForColumnIndex:0]];
                
            }
            
            [dbHelper CloseDB];
            
        }
    }
    
    
    if([tempArray count]==0){

        NSLog(@"iiiiiiii");
        
    }else{
   
        NSString *methoddd=@"getmyactivity";

        NSString *propertyyy=[NSString stringWithFormat:@"jsonid=%@",[MyJson ArrayToJsonString:tempArray]];
        
        NSString *httpJson=[HttpGet DoPost:methoddd property:propertyyy];
        
        if([httpJson isEqualToString:@"error"]){
            
            
        }else{
            
            NSMutableArray *arrayB=[MyJson JsonSringToArray:httpJson];
            
            for (int i = 0; i <[arrayB count]; i++) {
                
                NSMutableDictionary *rs=[arrayB objectAtIndex:i];
                
                InActivityBean *bean=[[InActivityBean alloc]init];
                
                bean._id=[rs objectForKey:@"id"];
                bean.title=[rs objectForKey:@"title"];
                bean.imgurl=[rs objectForKey:@"imgurl"];
                bean.category=[rs objectForKey:@"category"];
                bean.deadline=[Util dateFromString:[rs objectForKey:@"deadline"]];
                bean.time=[rs objectForKey:@"time"];
                bean.pridenum=[[rs objectForKey:@"pridenum"] integerValue];
                bean.opposenum=[[rs objectForKey:@"opposenum"] integerValue];
                bean.commentnum=[[rs objectForKey:@"commentnum"] integerValue];
                
                [ActivityArray addObject:bean];
                
            }
            
        }
        
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
    
    extern NSMutableArray *MyActivityArray;
    [MyActivityArray removeAllObjects];
    
    for(int i=0;i<[ActivityArray count];i++){
        
        [MyActivityArray addObject:[ActivityArray objectAtIndex:i]];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden =YES;
    
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
        return 1;
    }else{
        //extern NSMutableArray *MyActivityArray;
        return [ActivityArray count];
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        static NSString *simpleTableIdentifier = @"InActivityHeaderCell";
        
        InActivityHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        if(cell == nil){

            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityHeaderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        return cell;
        
    }else{
        static NSString *simpleTableIdentifier = @"InActivityItemCell";
        
        InActivityItemCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        
        //extern NSMutableArray *MyActivityArray;
        
        InActivityBean *bean=[ActivityArray objectAtIndex:indexPath.row];
        
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
        

        cell.dislike_num.text=[NSString stringWithFormat:@"%ld",bean.opposenum];
        cell.like_num.text=[NSString stringWithFormat:@"%ld",bean.pridenum];
        cell.comment_num.text=[NSString stringWithFormat:@"%ld",bean.commentnum];
        cell.sum_num.text=[self getSum:bean.pridenum oppose:bean.opposenum comment:bean.commentnum];
        
        
        
        NSInteger ty = -1;
        
        DBHelper *dbhelper=[[DBHelper alloc]init];
        
        [dbhelper CreateOrOpen];

        NSString *select=[NSString stringWithFormat:
                          @"select type from takepart where activityid='%@';",bean._id];
        
        FMResultSet *rs=[dbhelper QueryResult:select];
        
        if([rs next])
        {
            ty = [rs intForColumnIndex:0];
        }
        
        [dbhelper CloseDB];
        
        if (ty != -1) {
            if (ty == 0) {
                UIImage *liked = [UIImage imageNamed:@"support"];
                [cell.likeBt setImage:liked forState:UIControlStateNormal];
                UIImage *disliked = [UIImage imageNamed:@"against1"];
                [cell.dislikeBt setImage:disliked forState:UIControlStateNormal];
                
            } else {
                if (ty == 1) {
                    
                    UIImage *liked = [UIImage imageNamed:@"support1"];
                    [cell.likeBt setImage:liked forState:UIControlStateNormal];
                    UIImage *disliked = [UIImage imageNamed:@"against"];
                    [cell.dislikeBt setImage:disliked forState:UIControlStateNormal];
                    
                }
            }
        } else {
            
            UIImage *liked = [UIImage imageNamed:@"support"];
            [cell.likeBt setImage:liked forState:UIControlStateNormal];
            UIImage *disliked = [UIImage imageNamed:@"against"];
            [cell.dislikeBt setImage:disliked forState:UIControlStateNormal];
            
        }
        
        cell.title.tag=indexPath.row;
        cell.imgage.tag=indexPath.row;
        
        cell.title.userInteractionEnabled=YES;
        cell.imgage.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *imgTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMore:)];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMore:)];

        [cell.imgage addGestureRecognizer:imgTapGestureRecognizer];
        [cell.title addGestureRecognizer:labelTapGestureRecognizer];
        
        
        cell.likeBt.tag=indexPath.row;
        [cell.likeBt addTarget:self action:@selector(likeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dislikeBt.tag=indexPath.row;
        [cell.dislikeBt addTarget:self action:@selector(dislikeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.commentBt.tag=indexPath.row;
        [cell.commentBt addTarget:self action:@selector(commentBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.attendBt.hidden=YES;
        
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


-(void) showMore:(UITapGestureRecognizer *)recognizer{
    
    
    MyActivityDetailViewController *detail=[[MyActivityDetailViewController alloc]init];

    InActivityBean *bean=[ActivityArray objectAtIndex:recognizer.view.tag];
    
    detail.activityid=bean._id;
    detail.from=@"034";
    detail.titl=bean.title;
    detail.imgurl=bean.imgurl;
    detail.category=bean.category;
    detail.deadline=bean.deadline;
    detail.time=bean.time;
    detail.opposenum=bean.opposenum;
    detail.pridenum=bean.pridenum;
    detail.commentnum=bean.commentnum;
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}


- (void)likeBtClicked:(UIButton *)sender{
    
    //extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[ActivityArray objectAtIndex:sender.tag];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from takepart where activityid='%@'",bean._id];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        [dbhelper CloseDB];
        
        NSLog(@"您已经评价过了哦〜");
        
        [self.view makeToast:@"您已经评价过了哦〜"];
        
        return ;
        
    }
    
    NSString *insert=[NSString stringWithFormat:
                      @"insert into takepart values('%@','%d');",bean._id,1];
    
    [dbhelper excuteInfo:insert];
    
    [dbhelper CloseDB];
    
    //extern NSMutableArray *InActivityArray;
    
    bean.pridenum=bean.pridenum+1;
    
    [ActivityArray replaceObjectAtIndex:sender.tag withObject:bean];
    
    [activityTableView reloadData];
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=bean._id;
    judge.tag=1;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
   
    
}

- (void)dislikeBtClicked:(UIButton *)sender{
    
    //extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[ActivityArray objectAtIndex:sender.tag];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from takepart where activityid='%@'",bean._id];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        [dbhelper CloseDB];
        
        NSLog(@"您已经评价过了哦〜");
        
        [self.view makeToast:@"您已经评价过了哦〜"];
        
        return ;
        
    }
    
    NSString *insert=[NSString stringWithFormat:
                      @"insert into takepart values('%@','%d');",bean._id,0];
    
    [dbhelper excuteInfo:insert];
    
    [dbhelper CloseDB];
    
    //extern NSMutableArray *InActivityArray;
    
    bean.opposenum=bean.opposenum+1;
    
    [ActivityArray replaceObjectAtIndex:sender.tag withObject:bean];
    
    [activityTableView reloadData];
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=bean._id;
    judge.tag=0;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
    
}


- (void)commentBtClicked:(UIButton *)sender{
    
    MyActivityCommentViewController *detail=[[MyActivityCommentViewController alloc]init];
    
    InActivityBean *bean=[ActivityArray objectAtIndex:sender.tag];
    
    detail.activityid=bean._id;
    detail.from=@"034";
    detail.titl=bean.title;
    detail.imgurl=bean.imgurl;
    detail.category=bean.category;
    detail.deadline=bean.deadline;
    detail.time=bean.time;
    
    
    [self.navigationController pushViewController:detail animated:YES];

}


-(void)takepartactivity:(id)sender{
    
    ActivityJugeBean *judge=(ActivityJugeBean *)sender;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    NSString *method=@"takepartinactivity";
    NSString *property=[[[[[@"userid=" stringByAppendingString:userid] stringByAppendingString:@"&activityid="] stringByAppendingString:judge._id] stringByAppendingString:@"&type="] stringByAppendingString:[NSString stringWithFormat:@"%ld", judge.tag]];
    
    [HttpGet DoGet:method property:property];
    
}

-(void)RefreshData{
    
    [ActivityArray removeAllObjects];
    
    [self initArrayWithNet];
    
    [activityTableView reloadData];
    
}

-(void)LoadMoreData{

    InActivityBean *bean=ActivityArray.lastObject;
    
    NSString *cid=bean._id;
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
    if([dbHelper CreateOrOpen]==true){
        
        NSString *select=[NSString stringWithFormat:@"select * from attendactivity where activityid<'%@' order by activityid desc limit 3;",cid];
        
        FMResultSet *rs=[dbHelper QueryResult:select];
        
        
        while ([rs next])
        {
            [tempArray addObject:[rs stringForColumnIndex:0]];
            
        }
        
        [dbHelper CloseDB];
        
    }
    
    if([tempArray count]>0){
        
        NSString *methoddd=@"getmyactivity";
        
        NSString *propertyyy=[NSString stringWithFormat:@"jsonid=%@",[MyJson ArrayToJsonString:tempArray]];
        
        NSString *httpJson=[HttpGet DoPost:methoddd property:propertyyy];
        
        if([httpJson isEqualToString:@"error"]){
            
            
        }else{
            
            NSMutableArray *arrayB=[MyJson JsonSringToArray:httpJson];
            
            for (int i = 0; i <[arrayB count]; i++) {
                
                NSMutableDictionary *rs=[arrayB objectAtIndex:i];
                
                InActivityBean *bean=[[InActivityBean alloc]init];
                
                bean._id=[rs objectForKey:@"id"];
                bean.title=[rs objectForKey:@"title"];
                bean.imgurl=[rs objectForKey:@"imgurl"];
                bean.category=[rs objectForKey:@"category"];
                bean.deadline=[Util dateFromString:[rs objectForKey:@"deadline"]];
                bean.time=[rs objectForKey:@"time"];
                bean.pridenum=[[rs objectForKey:@"pridenum"] integerValue];
                bean.opposenum=[[rs objectForKey:@"opposenum"] integerValue];
                bean.commentnum=[[rs objectForKey:@"commentnum"] integerValue];
                
                [ActivityArray addObject:bean];
                
            }
            
        }
        
    }else{
        
        [self.view makeToast:@"亲～没有更多数据啦"];
        
    }
    
}


-(NSString *)getSum:(NSInteger)prideNum oppose:(NSInteger)opposeNum comment:(NSInteger)commentNum{
    
    double t1 = prideNum + 0.0 + commentNum * 2+ opposeNum, t = 0.0;
    if (t1 != 0) {
        t = ((prideNum + 0.0 + commentNum * 2 - opposeNum) * 10)/ t1;
    }
    
    return [NSString stringWithFormat:@"受欢迎程度:%.2f",t];
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
