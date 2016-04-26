//
//  InActivityViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/5.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "InActivityViewController.h"
#import "HttpGet.h"
#import "InActivityHeaderCell.h"
#import "InActivityItemCell.h"
#import "MJRefresh.h"
#import "MJRefreshFooter.h"
#import "ImageDownLoad.h"
#import "InActivityBean.h"
#import "Util.h"
#import "MyJson.h"
#import "UIView+Toast.h"
#import "DBHelper.h"
#import "ActivityJugeBean.h"
#import "InActivityDetailUIViewController.h"
#import "InActivityCommentViewController.h"
#import "OnlySignUpViewController.h"
#import "OtherTeamListViewController.h"

@interface InActivityViewController (){
    
    
    
}

@end

@implementation InActivityViewController

@synthesize activityTableView;
@synthesize changeTag;
@synthesize changeCommentTag;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self abc];
    
    activityTableView.separatorStyle = UITableViewCellSelectionStyleNone;

     self.navigationItem.title = @"校内精彩";//by lily

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
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    if(changeTag==1){
        
        [activityTableView reloadData];
    }
    
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
        extern NSMutableArray *InActivityArray;
        return [InActivityArray count];
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
        
       // NSString *schoolImg=[userDefaults objectForKey:@"SchoolImg"];
        
       // [ImageDownLoad setImageDownLoad:cell.imageView Url:schoolImg];
        
        return cell;
        
    }else{
        static NSString *simpleTableIdentifier = @"InActivityItemCell";
        
        InActivityItemCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

        if(cell == nil){
            
            NSLog(@"hahahahhahahaha");
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        

        
        extern NSMutableArray *InActivityArray;
        
        InActivityBean *bean=[InActivityArray objectAtIndex:indexPath.row];
        
        //cell.title.text=bean.title;
        cell.title.text=@"asasasasasasasasaaasasasasasasasasa121212sasasasaasasasa";
        
        
        [ImageDownLoad setImageDownLoad:cell.imgage Url:bean.imgurl];
        cell.categery.text=bean.category;
        
        NSDate *nowDate=[[NSDate alloc]init];
        
        if([nowDate compare:bean.deadline]==NSOrderedDescending){
            
            if([self getYear:bean.deadline]==1900){
                cell.deadline.text=@"";
            }else{
                [cell.deadline setTextColor:[UIColor redColor]];
                
                //cell.deadline.text=[[@"报名截止:" stringByAppendingString:[Util stringFromDate:bean.deadline]] stringByAppendingString:@"（已经截止）"];
                
                cell.deadline.text=[NSString stringWithFormat:@"报名截止:%@%@",[Util stringFromDate:bean.deadline],@"(已经截止)"];
                
            }
            
            //[cell.deadline setTextColor:[UIColor redColor]];
            
            //cell.deadline.text=[[@"报名截止:" stringByAppendingString:[Util stringFromDate:bean.deadline]] stringByAppendingString:@"（已经截止）"];

            
        }else{
            
            [cell.deadline setTextColor:[UIColor yellowColor]];
            
            //cell.deadline.text=[@"报名截止:" stringByAppendingString:[Util stringFromDate:bean.deadline]];

            cell.deadline.text=[NSString stringWithFormat:@"报名截止:%@",[Util stringFromDate:bean.deadline]];
            
        }
        
        
        NSRange range = [bean.time rangeOfString:@"~"];
        NSString *startTime = [bean.time substringToIndex:range.location];//开始截取
        NSString *endTime = [bean.time substringFromIndex:range.location+1];//开始截
        
        NSDate *runTime=[Util dateFromString:startTime];
        
        if([self getYear:runTime]==1900){
            
            cell.time.text=@"";
        }else{
            
            //cell.time.text=[@"活动时间:" stringByAppendingString:[[[Util stringFromDate:[Util dateFromString:startTime]] stringByAppendingString:@"~"] stringByAppendingString:[Util stringFromDate:[Util dateFromString:endTime]]]];
            
            cell.time.text=[NSString stringWithFormat:@"活动时间:%@~%@",[Util stringFromDate:[Util dateFromString:startTime]],[Util stringFromDate:[Util dateFromString:endTime]]];
            
        }
        
        //cell.time.text=[@"活动时间:" stringByAppendingString:[[[Util stringFromDate:[Util dateFromString:startTime]] stringByAppendingString:@"~"] stringByAppendingString:[Util stringFromDate:[Util dateFromString:endTime]]]];
        
        
        cell.dislike_num.text=[NSString stringWithFormat:@"%ld",bean.opposenum];
        cell.like_num.text=[NSString stringWithFormat:@"%ld",bean.pridenum];
        cell.comment_num.text=[NSString stringWithFormat:@"%ld",bean.commentnum];
        cell.sum_num.text=[self getSum:bean.pridenum oppose:bean.opposenum comment:bean.commentnum];
        
        
        
        NSInteger ty = -1;
        
        DBHelper *dbhelper=[[DBHelper alloc]init];
        
        [dbhelper CreateOrOpen];
    
        //NSString *ss=@"insert into notice(title ,publisher,content,time,cid,type) values('klaus','aaaa','hhhhh','ccccc','dddddd',1)";

        //NSString *ss1=@"insert into notice(title ,publisher,content,time,cid,type) values('klaus111','aaaa111','hhhhh111','ccccc','dddddd',1)";

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
        
        //[cell.title addGestureRecognizer:labelTapGestureRecognizer];
        [cell.imgage addGestureRecognizer:imgTapGestureRecognizer];
        [cell.title addGestureRecognizer:labelTapGestureRecognizer];
        

        cell.likeBt.tag=indexPath.row;
        [cell.likeBt addTarget:self action:@selector(likeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dislikeBt.tag=indexPath.row;
        [cell.dislikeBt addTarget:self action:@selector(dislikeBtClicked:) forControlEvents:UIControlEventTouchUpInside];

        
        cell.commentBt.tag=indexPath.row;
        [cell.commentBt addTarget:self action:@selector(commentBtClicked:) forControlEvents:UIControlEventTouchUpInside];

        cell.attendBt.tag=indexPath.row;
        [cell.attendBt addTarget:self action:@selector(attendBtClicked:) forControlEvents:UIControlEventTouchUpInside];

        
         return cell;
    }
    
    
}


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section==0){
//        return 105;
//    }else{
//        return 358;
//    }
    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // CGSize size;
    if(indexPath.section == 0){
        InActivityHeaderCell *cell = (InActivityHeaderCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        InActivityItemCell *itemcell = (InActivityItemCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return itemcell.frame.size.height;
    }
}

-(InActivityHeaderCell *) headerCell{
    if (!_headerCell) {
        _headerCell = [[NSBundle mainBundle] loadNibNamed:@"InActivityHeaderCell" owner:nil options:nil][0];
    }
    return _headerCell;
}

-(InActivityItemCell *) itemCell{
    if (!_itemCell) {
        
        NSLog(@"sasaasa");
        
        _itemCell = [[NSBundle mainBundle] loadNibNamed:@"InActivityItemCell" owner:nil options:nil][0];
    }
    return _itemCell;
}


-(NSString *)getSum:(NSInteger)prideNum oppose:(NSInteger)opposeNum comment:(NSInteger)commentNum{
    
    double t1 = prideNum + 0.0 + commentNum * 2+ opposeNum, t = 0.0;
    if (t1 != 0) {
        t = ((prideNum + 0.0 + commentNum * 2 - opposeNum) * 10)/ t1;
    }
    
    return [NSString stringWithFormat:@"受欢迎程度:%.2f",t];
    
    //return [@"受欢迎程度:" stringByAppendingString:[NSString stringWithFormat:@"%.2f",t]];
}

-(void)RefreshData{
    
    //get the _id of the schoool
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *schoolid =[userDefaults stringForKey:@"ShoolId"];
    
    //set the url and get the json from server
    
    NSString *method=@"getinactivity";
    NSString *property=[[@"schoolid=" stringByAppendingString:schoolid] stringByAppendingString:@"&currentid=0"] ;
    
    NSString *httpjson=[HttpGet DoGet:method property:property];
    
    if([httpjson isEqualToString:@"error"]){
        
        [self.view makeToast:@"您的网络连接不正常〜"];
        
    }else{
        
        extern NSMutableArray *InActivityArray;

        [InActivityArray removeAllObjects];
        
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
            bean.onlyteam=[[dic objectForKey:@"onlyteam"] integerValue];
            
            [InActivityArray addObject:bean];
            
        }
        
    }
    
}

-(void)LoadMoreData{
    
    //get the _id of the schoool
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *schoolid =[userDefaults stringForKey:@"ShoolId"];
    
    //set the url and get the json from server
    
    NSString *method=@"getinactivity";
    //StaticList.InActicitylist.get(StaticList.InActicitylist.size() - 1).id);
    
    extern NSMutableArray *InActivityArray;
    
    NSInteger len=[InActivityArray count];
    
    InActivityBean *temp=[InActivityArray objectAtIndex:(len-1)];
    
    NSString *currentId=temp._id;
    
    NSString *property=[[[@"schoolid=" stringByAppendingString:schoolid] stringByAppendingString:@"&currentid="] stringByAppendingString:currentId] ;
    
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
            bean.onlyteam=[[dic objectForKey:@"onlyteam"] integerValue];
            
            [InActivityArray addObject:bean];
            
        }
        
    }
    
}

-(void) showMore:(UITapGestureRecognizer *)recognizer{
    
    extern NSMutableArray *InActivityArray;
    
   // InActivityBean *bean=[InActivityArray objectAtIndex:recognizer.view.tag];

    InActivityDetailUIViewController *detail=[[InActivityDetailUIViewController alloc]init];
    detail.indexOfArray=recognizer.view.tag;
    
    detail.changeTag=0;
    
    [self.navigationController pushViewController:detail animated:NO];
    
 
}


- (void)likeBtClicked:(UIButton *)sender{

    extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];

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
    
    extern NSMutableArray *InActivityArray;
    
    bean.pridenum=bean.pridenum+1;
    
    [InActivityArray replaceObjectAtIndex:sender.tag withObject:bean];
    
    [activityTableView reloadData];
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=bean._id;
    judge.tag=1;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];

    
}

- (void)dislikeBtClicked:(UIButton *)sender{
    
    extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];
    
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
    
    [InActivityArray replaceObjectAtIndex:sender.tag withObject:bean];
    
    [activityTableView reloadData];
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=bean._id;
    judge.tag=0;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
    
}


- (void)commentBtClicked:(UIButton *)sender{
    
    extern NSMutableArray *InActivityArray;
    
    //  InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];
    
    InActivityCommentViewController *commentPage=[[InActivityCommentViewController alloc]init];
    
    commentPage.indexOfArray=sender.tag;
    commentPage.from=@"05";
    
    [self.navigationController pushViewController:commentPage animated:NO];
    
    
}

- (void)attendBtClicked:(UIButton *)sender{
    
    extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];
    
    if(bean.onlyteam==2){
        
        NSLog(@"此活动无需通过本软件报名");
        
        [self.view makeToast:@"此活动无需通过本软件报名"];
        
        return ;
        
    }else{
        
        Boolean flag=false;
        
        DBHelper *dbhelper=[[DBHelper alloc]init];
        
        [dbhelper CreateOrOpen];
        
        NSString *select=[NSString stringWithFormat:
                          @"select * from attendactivity where activityid='%@';",bean._id];
        
        FMResultSet *rs=[dbhelper QueryResult:select];
        
        if([rs next])
        {
            
            [dbhelper CloseDB];
            
            flag=true;
            
        }
        
        if(flag){
            
            NSLog(@"您已经报过名了哦〜〜");
            
            [self.view makeToast:@"您已经报过名了哦〜〜"];
            
            return ;
            
        }else{
            
            if(bean.onlyteam==0){
                
                OnlySignUpViewController *onlySign=[[OnlySignUpViewController alloc]init];
                //onlySign.from=@"05";
                onlySign.teamtag=0;
                onlySign.activityid=bean._id;
                
                [self.navigationController pushViewController:onlySign animated:NO];
                
            }else{
                
                OtherTeamListViewController *teamPage=[[OtherTeamListViewController alloc]init];

                teamPage.activityId=bean._id;
                teamPage.activityName=bean.title;

                [self.navigationController pushViewController:teamPage animated:NO];
                
            }
        
        }
        
    }

}


-(void)takepartactivity:(id)sender{
    
    ActivityJugeBean *judge=(ActivityJugeBean *)sender;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    NSString *method=@"takepartinactivity";
    NSString *property=[[[[[@"userid=" stringByAppendingString:userid] stringByAppendingString:@"&activityid="] stringByAppendingString:judge._id] stringByAppendingString:@"&type="] stringByAppendingString:[NSString stringWithFormat:@"%ld", judge.tag]];
    
    [HttpGet DoGet:method property:property];
    
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
