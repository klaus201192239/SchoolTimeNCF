//
//  InActivityDetailUIViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/14.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "InActivityDetailUIViewController.h"
#import "InActivityDetailTableViewCell.h"
#import "InActivityBean.h"
#import "ImageDownLoad.h"
#import "Util.h"
#import "DBHelper.h"
#import "UIView+Toast.h"
#import "ActivityJugeBean.h"
#import "InActivityCommentViewController.h"
#import "OnlySignUpViewController.h"
#import "OtherTeamListViewController.h"
#import "HttpGet.h"
#import "MBProgressHUD.h"
#import "MyJson.h"
#import "InActivityViewController.h"

@interface InActivityDetailUIViewController (){
    
    NSString *orgnization;
    NSString *contenthtml;
    NSString *attachmentname;
    NSInteger changeTagOther;
}

@end

@implementation InActivityDetailUIViewController

@synthesize myTableView;

@synthesize indexOfArray;
@synthesize changeTag;
//@synthesize changeCommentTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    changeTagOther=0;
    
    orgnization=@"";
    contenthtml=@"";
    attachmentname=@"";
    
        
    self.navigationItem.title = @"活动详情";//by lily


    [self AddNavigationBack];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取活动详细信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        extern NSMutableArray *InActivityArray;
        InActivityBean *bean=[InActivityArray objectAtIndex:indexOfArray];
        
        NSString *method=@"getinactivitydetail";
        NSString *property=[@"activityid=" stringByAppendingString:bean._id];
        
        NSString *httpJson=[HttpGet DoGet:method property:property];
        
        if([httpJson isEqualToString:@"error"]){
            
            
        }else{
            
            NSMutableDictionary *dic=[MyJson JsonSringToDictionary:httpJson];

            orgnization=[dic objectForKey:@"organization"];
            //obj.getString("organization");
            contenthtml =[dic objectForKey:@"content"];
            //obj.getString("content");
            attachmentname =[dic objectForKey:@"attachment"];
            //obj.getString("attachment");
            
            
        }
        
        [hud hide:YES];
        
        [myTableView reloadData];
        
        
    });
    

    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    if(changeTag==1){
        
        changeTagOther=1;
        
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
    
    
    extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[InActivityArray objectAtIndex:indexOfArray];
    
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

    
    cell.likeBt.tag=indexOfArray;
    [cell.likeBt addTarget:self action:@selector(likeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.dislikeBt.tag=indexOfArray;
    [cell.dislikeBt addTarget:self action:@selector(dislikeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.commentBt.tag=indexOfArray;
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
 
    InActivityViewController *activity=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        
    activity.changeTag=changeTagOther;
        
    [self.navigationController popToViewController:activity animated:TRUE];
        
 
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
    
    [myTableView reloadData];
    
    changeTagOther=1;
    
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
    
    extern NSMutableArray *InActivityArray;
    
    bean.opposenum=bean.opposenum+1;
    
    [InActivityArray replaceObjectAtIndex:sender.tag withObject:bean];
    
    [myTableView reloadData];
    
    changeTagOther=1;
    
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
    commentPage.from=@"06";
    
    [self.navigationController pushViewController:commentPage animated:NO];
    
    
}

-(IBAction)attendActivity:(id)sender{
    
    extern NSMutableArray *InActivityArray;
    
    InActivityBean *bean=[InActivityArray objectAtIndex:indexOfArray];
    
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
                onlySign.from=@"06";
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
            
            extern NSMutableArray *InActivityArray;
            
            InActivityBean *bean=[InActivityArray objectAtIndex:indexOfArray];
            
            NSString *_id=bean._id;
            
            NSString *method=@"sendattachment";
            //NSString *property=[[[[[@"activityid=" stringByAppendingString:_id] stringByAppendingString:@"&name="] stringByAppendingString:[Util encodeString:name]] stringByAppendingString:@"&email="] stringByAppendingString:email];
            
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

