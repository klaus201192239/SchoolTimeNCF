//
//  OutActivityViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "OutActivityViewController.h"
#import "InActivityItemCell.h"
#import "InActivityBean.h"
#import "ImageDownLoad.h"
#import "Util.h"
#import "DBHelper.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "MyJson.h"
#import "HttpGet.h"
#import "MJRefresh.h"
#import "ActivityJugeBean.h"
#import "OutActivityCommentViewController.h"
#import "OutActivityDetailViewController.h"

@interface OutActivityViewController (){
    
    NSMutableArray *CurrentActivityArray;
    
    NSString *currentpage;
    
}

@end

@implementation OutActivityViewController


@synthesize activityTableView;
@synthesize indexOfAChange;
@synthesize changeTag;

@synthesize prideChange;
@synthesize opposeChange;
@synthesize commentChange;

@synthesize currentActivityId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentpage=@"0";
    
    self.navigationItem.title = @"校外广场";//by lily
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    activityTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    CurrentActivityArray=[[NSMutableArray alloc]init];
    
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

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    if(changeTag==1){
        
        int lopTag=0;
        
        int acIndex=-1;
        
        for(int i=0;i<[CurrentActivityArray count]&&lopTag==0;i++){
            
            InActivityBean *bean=[CurrentActivityArray objectAtIndex:i];
            
            if([bean._id isEqualToString:currentActivityId]){
                
                lopTag=1;
                acIndex=i;

            }
            
        }
        
        
        if(acIndex!=-1){
            
            InActivityBean *bean1=[CurrentActivityArray objectAtIndex:acIndex];
            InActivityBean *bean2=[[InActivityBean alloc]init];
            
            bean2._id=bean1._id;
            bean2.title=bean1.title;
            bean2.imgurl=bean1.imgurl;
            bean2.category=bean1.category;
            bean2.deadline=bean1.deadline;
            bean2.time=bean1.time;
            bean2.pridenum=bean1.pridenum+prideChange;
            bean2.commentnum=bean1.commentnum+commentChange;
            bean2.opposenum=bean1.opposenum+opposeChange;
            

            [CurrentActivityArray replaceObjectAtIndex:acIndex withObject:bean2];
            
            
        }
        
        
        
        lopTag=0;
        acIndex=-1;
        
        extern NSMutableArray *OutActivityArray;
        
        for(int i=0;i<[OutActivityArray count]&&lopTag==0;i++){
            
            InActivityBean *bean=[OutActivityArray objectAtIndex:i];
            
            if([bean._id isEqualToString:currentActivityId]){
                
                lopTag=1;
                acIndex=i;
                
            }
            
        }

        
        if(acIndex!=-1){
            
            InActivityBean *bean1=[OutActivityArray objectAtIndex:acIndex];
            InActivityBean *bean2=[[InActivityBean alloc]init];
            
            bean2._id=bean1._id;
            bean2.title=bean1.title;
            bean2.imgurl=bean1.imgurl;
            bean2.category=bean1.category;
            bean2.deadline=bean1.deadline;
            bean2.time=bean1.time;
            bean2.pridenum=bean1.pridenum+prideChange;
            bean2.commentnum=bean1.commentnum+commentChange;
            bean2.opposenum=bean1.opposenum+opposeChange;
            
            
            [OutActivityArray replaceObjectAtIndex:acIndex withObject:bean2];
            
        }

        
        prideChange=0;
        opposeChange=0;
        commentChange=0;
        
        [activityTableView reloadData];
        
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [CurrentActivityArray count];
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"InActivityItemCell";
    
    InActivityItemCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.title.text=@"haha";
    
    InActivityBean *bean=[CurrentActivityArray objectAtIndex:indexPath.row];
    
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
                      @"select type from takepartout where activityid='%@';",bean._id];
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


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 348;
}

-(void)initDataArray{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        extern Boolean NetLink;
        if(NetLink==false){
            
            [self initArrayLocal];
            
        }else{
            
            [self initNetData];
            
        }

        extern NSMutableArray *OutActivityArray;
        
        for(int i=0;i<[OutActivityArray count];i++){
            
            InActivityBean *bean1=[OutActivityArray objectAtIndex:i];
            InActivityBean *bean2=[[InActivityBean alloc]init];
            
            bean2._id=bean1._id;
            bean2.title=bean1.title;
            bean2.imgurl=bean1.imgurl;
            bean2.category=bean1.category;
            bean2.deadline=bean1.deadline;
            bean2.time=bean1.time;
            bean2.pridenum=bean1.pridenum;
            bean2.opposenum=bean1.opposenum;
            bean2.commentnum=bean1.commentnum;

            
            
            [CurrentActivityArray addObject:bean2];
            
        }

    
        [hud hide:YES];
        
        [activityTableView reloadData];
        
        
    });
    
}


-(void)initArrayLocal{
  
    extern NSMutableArray *OutActivityArray;
    
    [OutActivityArray removeAllObjects];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];

    NSString *select=@"select * from outactivity order by id desc;";
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
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
        
        [OutActivityArray addObject:bean];
        
    }
    
    [dbhelper CloseDB];
    

}

-(void)initNetData{
     
     //set the url and get the json from server
     
     NSString *method=@"getoutactivity";
     NSString *property=@"classid=0&currentid=0" ;
     
     NSString *httpjson=[HttpGet DoGet:method property:property];

     
     if([httpjson isEqualToString:@"error"]){
     
         [self.view makeToast:@"您的网络连接不正常〜"];
     
     }else{
         
         extern NSMutableArray *OutActivityArray;
         
         [OutActivityArray removeAllObjects];
         
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
             
             [OutActivityArray addObject:bean];
         }
         
     }
    
}

-(void)RefreshData{
    
    //set the url and get the json from server
    
    NSString *method=@"getoutactivity";

    NSString *property=[[@"classid=" stringByAppendingString:currentpage] stringByAppendingString:@"&currentid=0"] ;
    
    NSString *httpjson=[HttpGet DoGet:method property:property];
    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
        extern NSMutableArray *OutActivityArray;
        
        [CurrentActivityArray removeAllObjects];
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjson];
        
        NSInteger length=[array count];
        
        
        if(length>0){
            
            if([currentpage isEqualToString:@"0"]){
                [OutActivityArray removeAllObjects];
            }

        }
        
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
            
            [CurrentActivityArray addObject:bean];
            
            if([currentpage isEqualToString:@"0"]){
                
                [OutActivityArray addObject:bean];
                
            }
            
        }
        
        
    }
    
    
}

-(void)LoadMoreData{

    NSInteger currentLength=[CurrentActivityArray count];

    InActivityBean *beannn=[CurrentActivityArray objectAtIndex:(currentLength-1)];

    NSString *method=@"getoutactivity";
    
    NSString *property= [NSString stringWithFormat:@"classid=%@&currentid=%@",currentpage,beannn._id];
    
    NSString *httpjson=[HttpGet DoGet:method property:property];
    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
        extern NSMutableArray *OutActivityArray;
        
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
            
            [CurrentActivityArray addObject:bean];
            
            if([currentpage isEqualToString:@"0"]){
                
                [OutActivityArray addObject:bean];
                
            }
            
        }
        
        
    }
    
}




-(IBAction)outAll:(id)sender{
    
    if([currentpage isEqualToString:@"0"]){
        return ;
    }
    currentpage=@"0";
    
    [CurrentActivityArray removeAllObjects];
    
    extern NSMutableArray *OutActivityArray;
    
    for(int i=0;i<[OutActivityArray count];i++){
        
        [CurrentActivityArray addObject:[OutActivityArray objectAtIndex:i]];
        
    }
    
    [activityTableView reloadData];
    
}
-(IBAction)outJiangzuo:(id)sender{

    if([currentpage isEqualToString:@"1"]){
        return ;
    }
    
    [self allClass:currentpage JumpPage:@"1"];
    
}
-(IBAction)outGongyi:(id)sender{
    
    if([currentpage isEqualToString:@"3"]){
        return ;
    }

    [self allClass:currentpage JumpPage:@"3"];

}
-(IBAction)outBisai:(id)sender{

    if([currentpage isEqualToString:@"2"]){
        return ;
    }
    
    [self allClass:currentpage JumpPage:@"2"];

}
-(IBAction)outOther:(id)sender{

    if([currentpage isEqualToString:@"4"]){
        return ;
    }
    
    [self allClass:currentpage JumpPage:@"4"];
    
}



-(void) allClass:(NSString *)curent JumpPage:(NSString *) jump{

    [CurrentActivityArray removeAllObjects];
    
    extern NSMutableArray *OutActivityArray;
    
    for(int i=0;i<[OutActivityArray count];i++){
        
        
        InActivityBean *bean1=[OutActivityArray objectAtIndex:i];
        //InActivityBean *bean2=[[InActivityBean alloc]init];
        
        if([[self getOutClassName:jump] isEqualToString:bean1.category]){
            
            InActivityBean *bean2=[[InActivityBean alloc]init];
            bean2._id=bean1._id;
            bean2.title=bean1.title;
            bean2.imgurl=bean1.imgurl;
            bean2.category=bean1.category;
            bean2.deadline=bean1.deadline;
            bean2.time=bean1.time;
            bean2.pridenum=bean1.pridenum;
            bean2.opposenum=bean1.opposenum;
            bean2.commentnum=bean1.commentnum;
            
            
            [CurrentActivityArray addObject:bean2];
            
        }

        
    }
    
    [activityTableView reloadData];
    
    currentpage=jump;
    
}


-(void) showMore:(UITapGestureRecognizer *)recognizer{
    
    
    InActivityBean *bean=[CurrentActivityArray objectAtIndex:recognizer.view.tag];
    
    OutActivityDetailViewController *detail=[[OutActivityDetailViewController alloc]init];
   
    
    detail.activityid=bean._id;
    detail.from=@"013";
    detail.titl=bean.title;
    detail.imgurl=bean.imgurl;
    detail.category=bean.category;
    detail.deadline=bean.deadline;
    detail.time=bean.time;
    detail.opposenum=bean.opposenum;
    detail.pridenum=bean.pridenum;
    detail.commentnum=bean.commentnum;
    
    
    [self.navigationController pushViewController:detail animated:NO];
    
    
}


- (void)likeBtClicked:(UIButton *)sender{
    
    InActivityBean *bean=[CurrentActivityArray objectAtIndex:sender.tag];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from takepartout where activityid='%@'",bean._id];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        [dbhelper CloseDB];
        
        NSLog(@"您已经评价过了哦〜");
        
        [self.view makeToast:@"您已经评价过了哦〜"];
        
        return ;
        
    }
    
    NSString *insert=[NSString stringWithFormat:
                      @"insert into takepartout values('%@','%d');",bean._id,1];
    
    [dbhelper excuteInfo:insert];
    
    [dbhelper CloseDB];
    
    
    bean.pridenum=bean.pridenum+1;
    
    [CurrentActivityArray replaceObjectAtIndex:sender.tag withObject:bean];

    [activityTableView reloadData];
    
    
    extern NSMutableArray *OutActivityArray;
    for(int j=0;j<[OutActivityArray count];j++){
        
        InActivityBean *beanB=[OutActivityArray objectAtIndex:j];
        
        if([bean._id isEqualToString:beanB._id]){
        
            [OutActivityArray replaceObjectAtIndex:j withObject:bean];

        }
        
    }
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=bean._id;
    judge.tag=1;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
    
    
}

- (void)dislikeBtClicked:(UIButton *)sender{
    
    InActivityBean *bean=[CurrentActivityArray objectAtIndex:sender.tag];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from takepartout where activityid='%@'",bean._id];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        [dbhelper CloseDB];
        
        NSLog(@"您已经评价过了哦〜");
        
        [self.view makeToast:@"您已经评价过了哦〜"];
        
        return ;
        
    }
    
    NSString *insert=[NSString stringWithFormat:
                      @"insert into takepartout values('%@','%d');",bean._id,0];
    
    [dbhelper excuteInfo:insert];
    
    [dbhelper CloseDB];

    
    bean.opposenum=bean.opposenum+1;
    
    [CurrentActivityArray replaceObjectAtIndex:sender.tag withObject:bean];
    
    [activityTableView reloadData];
    
    
    
    
    extern NSMutableArray *OutActivityArray;
    for(int j=0;j<[OutActivityArray count];j++){
        
        InActivityBean *beanB=[OutActivityArray objectAtIndex:j];
        
        if([bean._id isEqualToString:beanB._id]){
            
            [OutActivityArray replaceObjectAtIndex:j withObject:bean];
            
        }
        
    }

    
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=bean._id;
    judge.tag=0;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
   
    
}

-(void)takepartactivity:(id)sender{
    
    ActivityJugeBean *judge=(ActivityJugeBean *)sender;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    NSString *method=@"takepartoutactivity";
    NSString *property=[[[[[@"id=" stringByAppendingString:userid] stringByAppendingString:@"&activityid="] stringByAppendingString:judge._id] stringByAppendingString:@"&type="] stringByAppendingString:[NSString stringWithFormat:@"%ld", judge.tag]];
    
    [HttpGet DoGet:method property:property];
    
}



- (void)commentBtClicked:(UIButton *)sender{
    
    InActivityBean *bean=[CurrentActivityArray objectAtIndex:sender.tag];
    
    OutActivityCommentViewController *commentPage=[[OutActivityCommentViewController alloc]init];
    
    commentPage.activityid=bean._id;
    commentPage.from=@"013";
    commentPage.title=bean.title;
    commentPage.imgurl=bean.imgurl;
    commentPage.category=bean.category;
    commentPage.deadline=bean.deadline;
    commentPage.time=bean.time;
    //commentPage.indexOfArray=sender.tag;
    
    [self.navigationController pushViewController:commentPage animated:NO];
    
    
}


-(long)getYear:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear;
    comps = [calendar components:unitFlags fromDate:date];
    long year=[comps year];//获取年对应的长整形字符串
    return year;
    
}
-(NSString *)getSum:(NSInteger)prideNum oppose:(NSInteger)opposeNum comment:(NSInteger)commentNum{
    
    double t1 = prideNum + 0.0 + commentNum * 2+ opposeNum, t = 0.0;
    if (t1 != 0) {
        t = ((prideNum + 0.0 + commentNum * 2 - opposeNum) * 10)/ t1;
    }
    
    return [NSString stringWithFormat:@"受欢迎程度:%.2f",t];
}

-(NSString *)getOutClassName:(NSString *)jump{
    
    
    if([jump isEqualToString:@"1"]){
        
        return @"讲座";
        
    }
    if([jump isEqualToString:@"2"]){
        
        return @"公益";
        
    }
    if([jump isEqualToString:@"3"]){
        
        return @"比赛";
        
    }
    if([jump isEqualToString:@"4"]){
        
        return @"其他";
        
    }
    
    return @"其他";
    
}

@end
