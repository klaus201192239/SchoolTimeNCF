//
//  OutActivityDetailViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "OutActivityDetailViewController.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "InActivityDetailTableViewCell.h"
#import "ImageDownLoad.h"
#import "Util.h"
#import "DBHelper.h"
#import "UIView+Toast.h"
#import "ActivityJugeBean.h"
#import "OutActivityCommentViewController.h"
#import "OutActivityViewController.h"

@interface OutActivityDetailViewController (){
    
    NSString *orgnization;
    NSString *contenthtml;
    NSString *attachmentname;

}


@end

@implementation OutActivityDetailViewController

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
//@synthesize indexOfArray;

@synthesize changeTag;

@synthesize prideChange;
@synthesize opposeChange;
@synthesize commentChange;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    orgnization=@"";
    contenthtml=@"";
    attachmentname=@"";
    
    
    prideChange=0;
    opposeChange=0;
    commentChange=0;
    changeTag=0;
    
    self.navigationItem.title = @"活动详情";//by lily
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self AddNavigationBack];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取活动详细信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        
        NSString *method=@"getoutactivitydetail";
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

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    if(changeTag==1){
        
        commentnum=commentnum+commentChange;
        
        changeTag=1;
        
        [myTableView reloadData];
        
    }
   
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
    
    
    static NSString *simpleTableIdentifier = @"InActivityDetailTableViewCell";
    
    InActivityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityDetailTableViewCell" owner:self options:nil];
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
    
    
    cell.dislike_num.text=[NSString stringWithFormat:@"%ld",opposenum];
    cell.like_num.text=[NSString stringWithFormat:@"%ld",pridenum];
    cell.comment_num.text=[NSString stringWithFormat:@"%ld",commentnum];
    
    NSInteger ty = -1;
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select type from takepartout where activityid='%@';",activityid];
    
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
    
    
    cell.organization.text=orgnization;
    
    
    //label html
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[contenthtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    cell.content.attributedText=attrStr;
    
    if(attachmentname.length==0||attachmentname==nil||[attachmentname isEqualToString:@"nothing"]){
        
        cell.attachment.userInteractionEnabled=NO;
        
        cell.attachment.text=@"";
        
        
    }else{
        
        cell.attachment.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAttachment:)];
        
        [cell.attachment addGestureRecognizer:labelTapGestureRecognizer];
        
        NSMutableAttributedString *attachmentLine= [[NSMutableAttributedString alloc]initWithString:attachmentname];
        NSRange contentRange = {0,attachmentname.length};
        [attachmentLine addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        
        cell.attachment.attributedText = attachmentLine;
        
        
    }
    
    
    //cell.likeBt.tag=indexOfArray;
    [cell.likeBt addTarget:self action:@selector(likeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //cell.dislikeBt.tag=indexOfArray;
    [cell.dislikeBt addTarget:self action:@selector(dislikeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //cell.commentBt.tag=indexOfArray;
    [cell.commentBt addTarget:self action:@selector(commentBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}




-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 455+100;
}


-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    
    
    OutActivityViewController *activity=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    if(changeTag==1){
        
        activity.changeTag=1;
        activity.commentChange=commentChange;
        activity.opposeChange=opposeChange;
        activity.prideChange=prideChange;
        
    }else{
        
        
        activity.changeTag=0;
        
    }
    
    activity.currentActivityId=activityid;
    
    [self.navigationController popToViewController:activity animated:TRUE];
    
}

- (void)likeBtClicked:(UIButton *)sender{
    
    //InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from takepartout where activityid='%@'",activityid];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        [dbhelper CloseDB];
        
        NSLog(@"您已经评价过了哦〜");
        
        [self.view makeToast:@"您已经评价过了哦〜"];
        
        return ;
        
    }
    
    NSString *insert=[NSString stringWithFormat:
                      @"insert into takepartout values('%@',%d);",activityid,1];
    
    [dbhelper excuteInfo:insert];
    
    [dbhelper CloseDB];
    
    pridenum=pridenum+1;

    [myTableView reloadData];
    
    
    changeTag=1;
    prideChange++;
    
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=activityid;
    judge.tag=1;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
    
    
}

- (void)dislikeBtClicked:(UIButton *)sender{
    
    //InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];
    
    DBHelper *dbhelper=[[DBHelper alloc]init];
    
    [dbhelper CreateOrOpen];
    
    NSString *select=[NSString stringWithFormat:
                      @"select * from takepartout where activityid='%@'",activityid];
    
    FMResultSet *rs=[dbhelper QueryResult:select];
    
    if([rs next])
    {
        [dbhelper CloseDB];
        
        NSLog(@"您已经评价过了哦〜");
        
        [self.view makeToast:@"您已经评价过了哦〜"];
        
        return ;
        
    }
    
    NSString *insert=[NSString stringWithFormat:
                      @"insert into takepartout values('%@',%d);",activityid,0];
    
    [dbhelper excuteInfo:insert];
    
    [dbhelper CloseDB];

    
    opposenum=opposenum+1;
    
    [myTableView reloadData];

    changeTag=1;
    opposeChange++;
    
    
    ActivityJugeBean *judge=[[ActivityJugeBean alloc]init];
    judge._id=activityid;
    judge.tag=0;
    
    [NSThread detachNewThreadSelector:@selector(takepartactivity:) toTarget:self withObject:judge];
    
}


- (void)commentBtClicked:(UIButton *)sender{
    
    //  InActivityBean *bean=[InActivityArray objectAtIndex:sender.tag];
    
    OutActivityCommentViewController *commentPage=[[OutActivityCommentViewController alloc]init];

    
    commentPage.activityid=activityid;
    commentPage.from=@"014";
    commentPage.title=titl;
    commentPage.imgurl=imgurl;
    commentPage.category=category;
    commentPage.deadline=deadline;
    commentPage.time=time;
    //commentPage.indexOfArray=indexOfArray;

    [self.navigationController pushViewController:commentPage animated:NO];
    
    
}


-(void)takepartactivity:(id)sender{

    
    ActivityJugeBean *judge=(ActivityJugeBean *)sender;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    NSString *method=@"takepartoutactivity";
    NSString *property=[[[[[@"id=" stringByAppendingString:userid] stringByAppendingString:@"&activityid="] stringByAppendingString:judge._id] stringByAppendingString:@"&type="] stringByAppendingString:[NSString stringWithFormat:@"%ld", judge.tag]];
    
    [HttpGet DoGet:method property:property];
    
}


-(void) sendAttachment:(UITapGestureRecognizer *)recognizer{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *email=[userDefaults objectForKey:@"Email"];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送附件请求"
                                                  message:[NSString stringWithFormat: @"系统将会发送该附件至您的%@邮箱中〜",email]
                                                 delegate:self
                                        cancelButtonTitle:@"NO"
                                        otherButtonTitles:@"OK", nil];
    [alert show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText=@"正在发送邮件,请稍候！";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString *name=[userDefaults objectForKey:@"Name"];
            NSString *email=[userDefaults objectForKey:@"Email"];
         
            
            NSString *_id=activityid;
            
            NSString *method=@"sendattachmentout";
            NSString *property=[NSString stringWithFormat:@"activityid=%@&name=%@&email=%@",_id,[Util encodeString:name],email];
            
            
            [HttpGet DoGet:method property:property];
            
            
            [hud hide:YES];
            
            [self.view makeToast:@"发送成功～请到您的邮箱中查收"];
            
        });
        
    }
    
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

