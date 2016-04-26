//
//  ActivityIntegralViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/20.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ActivityIntegralViewController.h"
#import "UIView+Toast.h"
#import "DBHelper.h"
#import "objBean.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "HttpGet.h"
#import "MyJson.h"
#import "IntegralDetail.h"
#import "TypeTableViewCell.h"

@interface ActivityIntegralViewController (){
    NSInteger year;
    NSInteger mon;
    NSMutableArray *yearArray;
    NSMutableArray *typeArray;
    NSMutableArray *listDetail;
    NSMutableArray *listDetailSum;
    BOOL typeflag;
    UIColor *color;
}

@end

@implementation ActivityIntegralViewController
@synthesize typeTable;
@synthesize yearTable;
@synthesize yearButton;
@synthesize typeTileLabel;
@synthesize scoreLabel;
@synthesize detailTable;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackButton];
    typeflag=YES;
    
    detailTable.separatorStyle = UITableViewCellSelectionStyleNone;
    typeTable.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    yearArray=[[NSMutableArray alloc] init];
    typeArray=[[NSMutableArray alloc] init];
    listDetail=[[NSMutableArray alloc] init];
    listDetailSum=[[NSMutableArray alloc] init];
    
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM"];
    date = [formatter stringFromDate:[NSDate date]];

    year=[[date substringToIndex:4] intValue];
    mon=[[date substringFromIndex:5] intValue];
    if (mon<9) {
        year--;
    }
    [yearButton setTitle:[@"" stringByAppendingFormat:@"%ld~%ld学年",year,year+1] forState:UIControlStateNormal];
    
    yearTable.hidden=YES;
    yearArray=[[NSMutableArray alloc] init];
    [self initView];
    [self intiData];
    [self refleshView:@"0"];
    

    NSLog(@"init finish");
    
    yearTable.layer.borderWidth = 1;
    yearTable.layer.borderColor = [[UIColor grayColor] CGColor];
    
}

-(void)initView{

    NSString * u;
    for (NSInteger i=year; i>2010; i--) {
        u=[@"" stringByAppendingFormat:@"%ld~%ld学年",i,i+1];
        [yearArray addObject:u];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if ([tableView isEqual:typeTable]) {
        
        return [typeArray count]+1;
    }else if([tableView isEqual:yearTable]){
        return [yearArray count];
    }else{
        return [listDetail count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:typeTable]) {
        NSLog(@"enter type");
       /*  static NSString *CellIndentifier=@"TypeTableViewCell";
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell=[[TypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }*/
        static NSString *typeCellIdentifier=@"typeCellIdentifier";
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellIdentifier];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TypeTableViewCell" owner:self options:nil];
            if ([nib count]>0)
            {
                cell =[nib objectAtIndex:0];
            }
        }

        NSUInteger row=[indexPath row];
        
        if (row==0) {
            cell.cellLabel.text=@"所有类别";
            color=cell.cellLabel.backgroundColor;
            cell.cellLabel.backgroundColor=[UIColor colorWithRed:210/255.0 green:100/255.0 blue:20/255.0 alpha:0.5];
          //  cell.cellButton.titleLabel.text=@"所有类别";
        }else{
            objBean *bean=[typeArray objectAtIndex:row-1];
            cell.cellLabel.text=[@"" stringByAppendingFormat:@"%@",bean.name];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if([tableView isEqual:yearTable]){
        static NSString *TableCellIndentifier=@"CellIndentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellIndentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableCellIndentifier];
        }

        NSUInteger row=[indexPath row];
        cell.textLabel.text=[yearArray objectAtIndex:row];
        return cell;
        
    }else{
     //   NSLog(@"enter Detail");
        static NSString *TableCellIndentifier=@"CellIndentifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellIndentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableCellIndentifier];
        }
        NSUInteger row=[indexPath row];
        IntegralDetail *detail=[listDetail objectAtIndex:row];
        cell.textLabel.text=detail.name;
        cell.detailTextLabel.text=[@"" stringByAppendingFormat:@"%@ %@ %.2f积分",detail.Scope,detail.Level,detail.Grade];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:yearTable]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [yearButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        tableView.hidden=YES;
        year=[[cell.textLabel.text substringToIndex:4] intValue];
        typeflag=YES;
        [self intiData];
        [self refleshView:@"0"];
        [typeTable reloadData];
    }else if([tableView isEqual:typeTable]){
        
        TypeTableViewCell *cell = (TypeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //cell.cellButton.backgroundColor=[UIColor redColor];
        cell.cellLabel.backgroundColor=[UIColor colorWithRed:200/255.0 green:100/255.0 blue:20/255.0 alpha:0.5];
        typeflag=NO;
        for (NSInteger i=0;i<=[typeArray count];i++){
            NSIndexPath *path=[NSIndexPath indexPathForRow:i inSection:0];
            TypeTableViewCell *firstcell = (TypeTableViewCell *)[tableView cellForRowAtIndexPath:path];
            if (![firstcell isEqual:cell]) {
                firstcell.cellLabel.backgroundColor=color;
            }
        }
        NSInteger row = [indexPath row];
        if (row ==0) {
            [self refleshView:@"0"];
        }else {
            objBean *bean=[typeArray objectAtIndex:row-1];
            [self refleshView:[@"" stringByAppendingFormat:@"%@",bean._id]];
        }
        [detailTable reloadData];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
   
}

-(void)intiData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userid=[userDefaults stringForKey:@"Id"];
    NSString *idcard=[userDefaults stringForKey:@"StudentId"];
    NSString *schoolid=[userDefaults stringForKey:@"ShoolId"];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取数据,请稍候！";
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString * httpjson=nil;
        
        @try {
            NSString *pro=[[NSString alloc] initWithFormat:@"userid=%@&year=%ld&schoolid=%@&idcard=%@" ,userid,year,schoolid,idcard];
            NSLog(@"%@",pro);
            httpjson=[HttpGet DoGet:@"getActivityIntegral" property:pro];
            
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        
        NSLog(@"%@",httpjson);
        
        [hud hide:YES];
        if([httpjson isEqualToString:@"error"]){
            [self handleMessage:0];
            
        }else{
            
            //NSLog(@"enter");
            [listDetailSum removeAllObjects];
            [typeArray removeAllObjects];
            [listDetail removeAllObjects];
            NSMutableArray *array=[MyJson JsonSringToArray:httpjson];
            NSInteger len=[array count];
            for (NSInteger i=0; i<len; i++) {

                NSMutableDictionary *jsonobj=[array objectAtIndex:i];
                objBean *bean=[[objBean alloc]init];
                
                bean._id=[jsonobj objectForKey:@"id"];
                bean.name=[jsonobj objectForKey:@"name"];
                
                NSMutableArray *arrayB=[jsonobj objectForKey:@"detail"];
                NSInteger lenB=[arrayB count];
                for (NSInteger j=0; j<lenB; j++) {

                    NSMutableDictionary *jsonobjB=[arrayB objectAtIndex:i];
                    
                    IntegralDetail *detail=[[IntegralDetail alloc]init];
                    NSLog(@"bean.id=%@",bean._id);
                    
                    detail.Classid=bean._id;
                    detail.Grade=[[jsonobjB objectForKey:@"grade"] doubleValue];
                    detail.Level=[jsonobjB objectForKey:@"level"];
                    detail.name=[jsonobjB objectForKey:@"name"];
                    detail.Scope=[jsonobjB objectForKey:@"scope"];
                    
                   
                //    NSLog(@"detail.classid=%@",detail.Classid);
                 //   NSLog(@"detail.Level=%@",detail.Level);
                    
                    [listDetailSum addObject:detail];
                }
                
                NSLog(@"bean.id=%@",bean._id);
                [typeArray addObject:bean];
            }
            [self handleMessage:1];
        }

    });
}

-(void)handleMessage:(NSInteger)flag{
    if (flag == 0) {
        [self.view makeToast:@"网络连接或其他意外错误"];
    }
    if (flag == 1) {

        [self.view makeToast:@"操作成功〜"];
        [self refleshView:@"0"];

    }
}

-(void) refleshView:(NSString *)classid{
    double sumInte=0.0;
     [listDetail removeAllObjects];
    if ([classid isEqualToString:@"0"]) {
        
        NSInteger len=[listDetailSum count];
        
        for (NSInteger i=0; i<len; i++) {
            IntegralDetail *detail=[listDetailSum objectAtIndex:i];
            sumInte=sumInte+detail.Grade;
        }
        for (NSInteger i=0; i<[listDetailSum count]; i++) {
            IntegralDetail *detail=[listDetailSum objectAtIndex:i];
            [listDetail addObject:detail];
        }
    }else{
        
       // NSLog(@"enter reflesh:%@",classid);
        [listDetail removeAllObjects];
        NSInteger le=[listDetailSum count];
        for (NSInteger i=0; i<le; i++) {
            IntegralDetail *detail=[listDetailSum objectAtIndex:i];
            if ([detail.Classid isEqualToString:classid]) {
                [listDetail addObject:detail];
                sumInte=sumInte+detail.Grade;
            }
        }
    }
    scoreLabel.text=[@"" stringByAppendingFormat:@"%.1f",sumInte];

    if ([classid isEqualToString:@"0"]) {
        typeTileLabel.text=@"所有类别";
    }else{
        for (NSInteger i=0; i<[typeArray count]; i++) {
            objBean *bean=[typeArray objectAtIndex:i];
            if ([bean._id isEqualToString:classid]) {
                typeTileLabel.text=[@"" stringByAppendingFormat:@"%@积分",bean.name];
            }
        }
    }
    
   // NSLog(@"first reflesh");
    [detailTable reloadData];
    if (typeflag) {
        [typeTable reloadData];
    }
    
}

-(IBAction)pressYearButton:(id)sender{
    yearTable.hidden=NO;
}

-(IBAction)backgroundTap:(id)sender{
    yearTable.hidden=YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
