//
//  ManagerActivityDetailViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ManagerActivityDetailViewController.h"
#import "InActivityBean.h"
#import "ImageDownLoad.h"
#import "Util.h"
#import "DBHelper.h"
#import "UIView+Toast.h"
#import "ActivityJugeBean.h"
#import "HttpGet.h"
#import "MBProgressHUD.h"
#import "MyJson.h"
#import "ManagerDetailTableViewCell.h"
#import "MyActivityCommentViewController.h"
#import "ManagerActivityPersonViewController.h"
#import "CallOverViewController.h"


@interface ManagerActivityDetailViewController (){
    
    NSString *orgnization;
    NSString *contenthtml;
    NSString *attachmentname;
    
}


@end

@implementation ManagerActivityDetailViewController


@synthesize myTableView;

@synthesize activityid;
@synthesize from;
@synthesize titl;
@synthesize imgurl;
@synthesize category;
@synthesize deadline;
@synthesize time;
@synthesize opposenum;
@synthesize pridenum;
@synthesize commentnum;
@synthesize orgnizationid;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self AddNavigationBack];
    [self AddNavigationRight];
    
    
    orgnization=@"";
    contenthtml=@"";
    attachmentname=@"";
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.navigationItem.title = @"活动详情";//by lily
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取活动详细信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *method=@"getinactivitydetail";
        NSString *property=[@"activityid=" stringByAppendingString:activityid];
        
        NSString *httpJson=[HttpGet DoGet:method property:property];
        
        if([httpJson isEqualToString:@"error"]){
            
            
        }else{
            
            NSMutableDictionary *dic=[MyJson JsonSringToDictionary:httpJson];
            
            orgnization=[dic objectForKey:@"organization"];
            contenthtml =[dic objectForKey:@"content"];
            attachmentname =[dic objectForKey:@"attachment"];
            
        }
        
        [hud hide:YES];
        
        [myTableView reloadData];
        
        
    });
    
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



-(void)AddNavigationRight{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"qitabaoming.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goRightAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem=back;
}

-(void)goRightAction{
    
    ManagerActivityPersonViewController *per=[[ManagerActivityPersonViewController alloc]init];
    per.activityid=activityid;
    per.tit=titl;
    per.orgnization=orgnization ;
    per.orgnizationid=orgnizationid;
    [self.navigationController pushViewController:per animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"ManagerDetailTableViewCell";
    
    ManagerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ManagerDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.title.text=titl;
    [ImageDownLoad setImageDownLoad:cell.imgage Url:imgurl];
    cell.categery.text=category;
    
    NSDate *nowDate=[[NSDate alloc]init];
    
    if([nowDate compare:deadline]==NSOrderedDescending){
        
        if([self getYear:deadline]==1900){
            cell.deadline.text=@"";
        }else{
            [cell.deadline setTextColor:[UIColor redColor]];
            
            cell.deadline.text=[NSString stringWithFormat:@"报名截止:%@%@",[Util stringFromDate:deadline],@"(已经截止)"];
            
        }
        
    }else{
        
        [cell.deadline setTextColor:[UIColor yellowColor]];
        
        cell.deadline.text=[NSString stringWithFormat:@"报名截止:%@",[Util stringFromDate:deadline]];
        
        
    }
    
    
    NSRange range = [time rangeOfString:@"~"];
    NSString *startTime = [time substringToIndex:range.location];//开始截取
    NSString *endTime = [time substringFromIndex:range.location+1];//开始截
    
    NSDate *runTime=[Util dateFromString:startTime];
    
    if([self getYear:runTime]==1900){
        
        cell.time.text=@"";
    }else{
        
        cell.time.text=[NSString stringWithFormat:@"活动时间:%@~%@",[Util stringFromDate:[Util dateFromString:startTime]],[Util stringFromDate:[Util dateFromString:endTime]]];
        
    }
    
    [cell.dislike_num setTextColor:[UIColor redColor]];
    [cell.like_num setTextColor:[UIColor blueColor]];
    
    cell.dislike_num.text=[NSString stringWithFormat:@"支持 %ld",opposenum];
    cell.like_num.text=[NSString stringWithFormat:@"反对 %ld",pridenum];
  //  cell.dislike_num.text=[NSString stringWithFormat:@"%ld",opposenum];
    //cell.like_num.text=[NSString stringWithFormat:@"%ld",pridenum];
    cell.comment_num.text=[NSString stringWithFormat:@"%ld",commentnum];
    
    
    cell.organization.text=orgnization;
    
    
    //label html
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[contenthtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    cell.content.attributedText=attrStr;
    
    if(attachmentname.length==0||attachmentname==nil||[attachmentname isEqualToString:@"nothing"]){
        
        cell.attachment.text=@"";
        
        
    }else{
        
        NSMutableAttributedString *attachmentLine= [[NSMutableAttributedString alloc]initWithString:attachmentname];
        NSRange contentRange = {0,attachmentname.length};
        [attachmentLine addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        
        cell.attachment.attributedText = attachmentLine;

    }
    
    cell.commentBt.tag=indexPath.row;
    [cell.commentBt addTarget:self action:@selector(commentBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 455+100;
}



- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}





- (void)commentBtClicked:(UIButton *)sender{
    
    MyActivityCommentViewController *detail=[[MyActivityCommentViewController alloc]init];
    
    detail.activityid=activityid;
    detail.from=@"025";
    detail.titl=titl;
    detail.imgurl=imgurl;
    detail.category=category;
    detail.deadline=deadline;
    detail.time=time;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(IBAction)startSignIn:(id)sender{
    
    CallOverViewController *call=[[CallOverViewController alloc]init];
    call.activityid=activityid;
    call.titl=titl;
    call.orgnization=orgnization ;
    call.orgnizationid=orgnizationid;
    call.contenthtml=contenthtml;
    call.attachmentname=attachmentname;
    [self.navigationController pushViewController:call animated:YES];
    
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
