//
//  RegisterSchoolViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/11.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "RegisterSchoolViewController.h"
#import "TxtTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "Util.h"
#import "RegisterInfoViewController.h"
#import "UserInformationViewController.h"

@interface RegisterSchoolViewController (){
    
    NSMutableArray *schoolTableArray;//只是 存储用于显示在TableView上的数据
    NSMutableArray *schoolArray;//存储所有的学校的所有信息

    
    NSMutableArray *cityTableArray;//只是 存储用于显示在省份和城市的信息
    NSMutableArray *cityArray;//用于存储所有的省份和城市信息
    
    NSInteger tagTable;//1---province   2----city

}

@end

@implementation RegisterSchoolViewController

@synthesize city;
@synthesize province;
@synthesize myTable;
@synthesize cityTable;

@synthesize chooseCity;
@synthesize choosePro;



@synthesize UserId;
@synthesize Phone;
@synthesize Pwd;
@synthesize From;
@synthesize UserRealName;
@synthesize Sex;
@synthesize Degree;
@synthesize Grade;
@synthesize SchoolId;
@synthesize SchoolName;
@synthesize MajorName;
@synthesize Education;
@synthesize Email;
@synthesize StudentId;
@synthesize MajorId;
@synthesize MajorInfo;
@synthesize SchoolImg;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"查 询 大 学";
    
    schoolTableArray=[NSMutableArray arrayWithObjects:@"temp",nil];
    schoolArray=[NSMutableArray arrayWithObjects:@"temp",nil];
    cityTableArray=[NSMutableArray arrayWithObjects:@"temp",nil];
    cityArray=[NSMutableArray arrayWithObjects:@"temp",nil];

    cityTable.hidden=YES;
    
    [self AddNavigationBack];
    
    cityTable.tag=1;
    myTable.tag=2;
    
    cityTable.separatorStyle = UITableViewCellSelectionStyleNone;
    myTable.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self initData];
    
}


-(void)initData{
    
    
    tagTable=1;
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        NSString *pro=nil;
        
        NSString * httpjson=[HttpGet DoGet:@"registercity" property:pro];
        
        if([httpjson isEqualToString:@"error"]){
            
            [self.view makeToast:@"网络连接或其他意外错误"];
            
        }else{
     
            if([httpjson isEqualToString:@"nothing"]){
                
                [self.view makeToast:@"该城市还未开放服务，敬请期待〜"];
                
            }else{
                
                cityArray=[MyJson JsonSringToArray:httpjson];
                
                NSDictionary *dic=[cityArray objectAtIndex:0];
                
                NSArray *array=[dic objectForKey:@"city"];
                
                [province setTitle:[dic objectForKey:@"pro"] forState:UIControlStateNormal];
                [city setTitle:[array objectAtIndex:0] forState:UIControlStateNormal];
                
                
                choosePro=[dic objectForKey:@"pro"] ;
                chooseCity=[array objectAtIndex:0] ;
                
            }
        }
        
        [hud hide:YES];
  
    });
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) viewDidAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    cityTable.hidden=YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(IBAction)choosePro:(id)sender{
    
    [cityTableArray removeAllObjects];
    
    for(int i=0;i<[cityArray count];i++){
        
        NSDictionary *dic=[cityArray objectAtIndex:i];
        
        [cityTableArray addObject:[dic objectForKey:@"pro"]];
        
    }
    
    [cityTable reloadData];
    
    cityTable.hidden=NO;
    
    tagTable=1;
    
}
-(IBAction)chooseCity:(id)sender{
    
    [cityTableArray removeAllObjects];
    
    NSInteger tag=0;
    
    for(int i=0;i<[cityArray count]&&tag==0;i++){
        
        NSDictionary *dic=[cityArray objectAtIndex:i];
        
        if([choosePro isEqualToString:[dic objectForKey:@"pro"]]){
            
            NSArray *array=[dic objectForKey:@"city"];
            
            for(int j=0;j<[array count];j++){
                
                [cityTableArray addObject:[array objectAtIndex:j]];
                
            }
            
            tag=1;
            
        }
        
    }
    
    [cityTable reloadData];
    
    cityTable.hidden=NO;
    
    tagTable=2;
    
    
}
-(IBAction)search:(id)sender{
    
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSInteger tag=0;
        
        NSString *pro=[[[@"schoolpro=" stringByAppendingString:[Util encodeString:choosePro]] stringByAppendingString:@"&schoolcity="] stringByAppendingString:[Util encodeString:chooseCity]];
        
        NSString * httpjson=[HttpGet DoGet:@"registerschool" property:pro];
        
        if([httpjson isEqualToString:@"error"]){
            
            [self.view makeToast:@"网络连接或其他意外错误"];
            
        }else{
            
            if([httpjson isEqualToString:@"nothing"]){
                
                [self.view makeToast:@"该城市还未开放服务，敬请期待〜"];
                tag=1;
                
            }else{
                
                schoolArray=[MyJson JsonSringToArray:httpjson];

                tag=2;
                
            }
        }
        
        [hud hide:YES];
        
        if(tag==1){
            
            [schoolTableArray removeAllObjects];
            
            [schoolTableArray addObject:@"该城市还未开放服务，敬请期待〜"];
            
            [myTable reloadData];
            
            
        }else{
            
            if(tag==2){
                
                [schoolTableArray removeAllObjects];
                
                for(int i=0;i<[schoolArray count];i++){
                    
                    NSDictionary *dic=[schoolArray objectAtIndex:i];
                    
                    [schoolTableArray addObject:[dic objectForKey:@"Name"]];
                    
                }
                
                [myTable reloadData];
                
                
            }
        }
        
    });
    
}

-(void)goBackAction{
    
   // [self.navigationController popViewControllerAnimated:YES];
    
    RegisterInfoViewController *info=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    info.From=@"00";
    
    [self.navigationController popToViewController:info animated:TRUE];
    
    
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TxtTableViewCell";
    
    TxtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TxtTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    if(tableView.tag==1){
        
        cell.label.text = [cityTableArray objectAtIndex:indexPath.row];

    }else{
        
        
        cell.label.text = [schoolTableArray objectAtIndex:indexPath.row];

        
    }
    
    
    return cell;
}

//设置列表的每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    
    if(tableView.tag==1){
        
        cityTable.hidden=YES;
        
        if(tagTable==1){
            
            NSDictionary *dic=[cityArray objectAtIndex:indexPath.row];
            
            NSArray *array=[dic objectForKey:@"city"];
            
            [province setTitle:[dic objectForKey:@"pro"] forState:UIControlStateNormal];
            [city setTitle:[array objectAtIndex:0] forState:UIControlStateNormal];
            
            choosePro=[dic objectForKey:@"pro"] ;
            chooseCity=[array objectAtIndex:0] ;
            
        }else{
            
            chooseCity=[cityTableArray objectAtIndex:indexPath.row];
            [city setTitle:chooseCity forState:UIControlStateNormal];
            
        }
        
    }
    
    else{
        
        
        if([From isEqualToString:@"03"]){
            
            NSDictionary *dic=[schoolArray objectAtIndex:indexPath.row];
            
            RegisterInfoViewController *info=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            
            info.SchoolImg=[dic objectForKey:@"ShowUrl"];
            info.SchoolName=[dic objectForKey:@"Name"];
            info.SchoolId=[dic objectForKey:@"_id"];
            info.MajorInfo=[dic objectForKey:@"Major"];
            info.From=@"04";
            
            [self.navigationController popToViewController:info animated:TRUE];
            
        }

        else{
            
            
            NSDictionary *dic=[schoolArray objectAtIndex:indexPath.row];
            
            UserInformationViewController *info=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            
            
            info.SchoolImg=[dic objectForKey:@"ShowUrl"];
            info.SchoolName=[dic objectForKey:@"Name"];
            info.SchoolId=[dic objectForKey:@"_id"];
            info.MajorInfo=[dic objectForKey:@"Major"];
            info.From=@"04";
            
            info.UserId=UserId;
            info.Phone=Phone;
            info.Pwd=Pwd;
            info.UserRealName=UserRealName;
            info.Sex=Sex;
            info.Degree=Degree;
            info.Grade=Grade;
            info.Email=Email;
            info.StudentId=StudentId;
            
            [self.navigationController popToViewController:info animated:TRUE];
            
            
        }
  
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag==1){
        
        return [cityTableArray count] ;
        
    }else{
        
        return [schoolTableArray count] ;
   
    }
    
}

-(void)AddNavigationBack{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(5, 5, 38, 38);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"wm_back2.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=back;
}



@end
