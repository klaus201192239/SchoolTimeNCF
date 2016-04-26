//
//  NoticeViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/16.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "NoticeViewController.h"
#import "UIView+Toast.h"
#import "DBHelper.h"
#import "NoticeBean.h"
#import "Util.h"
#import "NoticeDetailViewController.h"

@interface NoticeViewController (){
    
    NSMutableArray *noticeArray;
}

@end

@implementation NoticeViewController

//@synthesize noticeArray;

@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    myTableView.delegate=self;
    
    noticeArray=[[NSMutableArray alloc]init];
    
    
    self.navigationItem.title = @"消息通知";//by lil

    [self addBackButton];
    
    extern Boolean NetLink;
    
    if(NetLink==false){
        
        [self.view makeToast:@"网络接连不可用"];
        
        return ;
    }
    
    
    NSLog(@"enter!");
    
    //NSInteger count=0;
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
    
    if([dbHelper CreateOrOpen]==true){
    
       // [dbHelper excuteInfo:@"drop table notice;"];
       //[dbHelper excuteInfo:@"CREATE TABLE notice(id int identity(1,1) primary key,title text,publisher text,content text,time text,cid text,type int);"];

       //[dbHelper excuteInfo:@"insert into notice(title,publisher,content,time,cid,type) values('关于对方公司股份','教务','山东粉色人格虽然个人风格人格跟谁玩儿个人','Sat Oct 10 12:00:00 UTC 2015','8888',1);"];

       // [dbHelper excuteInfo:@"delete from notice;"];
        
        FMResultSet *rs=[dbHelper QueryResult:@"select * from notice order by id desc;"];
        
        while ([rs next])
        {
            
            NoticeBean *bean=[[NoticeBean alloc]init];
            
            bean._id=[rs intForColumnIndex:0];
            bean.title=[rs stringForColumnIndex:1];
            bean.publisher=[rs stringForColumnIndex:2];
            bean.content=[rs stringForColumnIndex:3];
            bean.time=[Util dateFromString:[rs stringForColumnIndex:4]];
         
            [noticeArray addObject:bean];
            
            
            NSLog(@"%ld",bean._id);
             NSLog(@"%@",bean.title);
             NSLog(@"%@",bean.publisher);
            
        }
        
        [dbHelper CloseDB];
        
        //StaticArray.InActivityArray=tempArray;
        
    }
    
    [myTableView reloadData];
    
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
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [noticeArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PersidentsCellIdentifier=@"PersidentsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersidentsCellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PersidentsCellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    
    NoticeBean *bean=[noticeArray objectAtIndex:row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.text=bean.title;
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:19];
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    cell.detailTextLabel.textAlignment=NSTextAlignmentLeft;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    cell.detailTextLabel.text=[dateFormatter stringFromDate:bean.time];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger row=[indexPath row];
    NoticeBean *bean=[noticeArray objectAtIndex:row];

    
    NoticeDetailViewController *noticeDetail=[[NoticeDetailViewController alloc] init];
    noticeDetail.title=@"通知详情";
    //[self.navigationController pushViewController:noticeDetail animated:YES];

    
    noticeDetail.tit=bean.title;
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    noticeDetail.time=[dateFormatter stringFromDate:bean.time];
    noticeDetail.content=bean.content;
    noticeDetail.publisher=bean.publisher;
    
    [self.navigationController pushViewController:noticeDetail animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
