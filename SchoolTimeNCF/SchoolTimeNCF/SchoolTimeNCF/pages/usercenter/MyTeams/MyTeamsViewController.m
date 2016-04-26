//
//  MyTeamsViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/18.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "MyTeamsViewController.h"
#import "UIView+Toast.h"
#import "DBHelper.h"
#import "MyTeamBean.h"
#import "Util.h"
#import "MyTeamTableViewCell.h"
#import "ExamineTeamViewController.h"

@interface MyTeamsViewController (){
    NSMutableArray *teamArray;
}
@end

@implementation MyTeamsViewController
@synthesize teamTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButton];
    
    teamTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    teamArray=[[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"团队管理";//by lil
    
    extern Boolean NetLink;
    
    if(NetLink==false){
        
        [self.view makeToast:@"网络接连不可用"];
        
        return ;
    }
    [self intiData];
    
}


-(void) intiData{
  //  NSInteger count=0;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userid=[userDefaultes stringForKey:@"Id"];
    NSString *idcard=[userDefaultes stringForKey:@"StudentId"];
    
 //   NSLog(@"userid=%@",userid);
  //  NSLog(@"idcard=%@",idcard);
    
    DBHelper *dbHelper=[[DBHelper alloc]init];
  //  NSLog(@"count=%ld",count);
    
    if([dbHelper CreateOrOpen]==true){
       
        
        FMResultSet *rs=[dbHelper QueryResult:@"select * from myteam order by id desc;"];
        
        while ([rs next])
        {
          //  NSLog(@"count=%ld",count++);
            
            MyTeamBean *bean=[[MyTeamBean alloc]init];
            
            bean._id=[rs stringForColumnIndex:0];
            bean.activityname=[rs stringForColumnIndex:5];
            bean.name=[@"" stringByAppendingFormat:@"%@(%@)",[rs stringForColumnIndex:1],[rs stringForColumnIndex:4]];
            
        
            FMResultSet *rss=[dbHelper QueryResult:[NSString stringWithFormat:@"select count(*) from teammember where teamid= '%@';",bean._id]];
            
            while ([rss next]) {
                bean.memberSum=[rss intForColumnIndex:0];

            }
            
            NSLog(@"%@",[rss stringForColumnIndex:2]);
            
            if ([userid isEqualToString:[rs stringForColumnIndex:2]]||[idcard isEqualToString:[rs stringForColumnIndex:3]]) {
                bean.power=1;
            }else{
                bean.power=0;
            }

            [teamArray addObject:bean];
            
            
        }
        
        [dbHelper CloseDB];
        
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden =YES;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [teamArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myTeamCellIdentifier=@"MyTeamCellIdentifier";
    MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTeamCellIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTeamTableViewCell" owner:self options:nil];
        if ([nib count]>0)
        {
            cell =[nib objectAtIndex:0];
        }
        
    }
    
    MyTeamBean *bean=[teamArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=bean.name;
    cell.subLabel.text=bean.activityname;
    cell.numLabel.text=[@"共有" stringByAppendingFormat:@"%ld人申请加入",bean.memberSum];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row=[indexPath row];
    MyTeamBean *bean=[teamArray objectAtIndex:row];
    
    ExamineTeamViewController *memberView=[[ExamineTeamViewController alloc] init];
    memberView.title=@"团队管理";
    
    memberView.power=bean.power;
    memberView.teamid=bean._id;
    
    [self.navigationController pushViewController:memberView animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
