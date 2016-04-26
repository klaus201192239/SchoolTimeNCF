//
//  ChooseOrganizationViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/23.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "ChooseOrganizationViewController.h"
#import "TxtTableViewCell.h"
#import "ManagerActivityListViewController.h"

@interface ChooseOrganizationViewController (){
    
    NSMutableArray *tableArray;
    
}

@end

@implementation ChooseOrganizationViewController


@synthesize oganization;
@synthesize myTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"部门选择";//by lil
    
    [self addBackButton];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    myTable.separatorStyle = UITableViewCellSelectionStyleNone;

    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)initData{
    
    
    tableArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[oganization count];i++){
        
        
        NSDictionary *dic=[oganization objectAtIndex:i];
        
        [tableArray addObject:[dic objectForKey:@"name"]];
        
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TxtTableViewCell";
    
    TxtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TxtTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
  
    cell.label.text = [tableArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

//设置列表的每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
    NSDictionary *dic=[oganization objectAtIndex:indexPath.row];
    
    ManagerActivityListViewController *mana=[[ManagerActivityListViewController alloc]init];
    
    mana.oganizationid=[dic objectForKey:@"id"];
    
    [self.navigationController pushViewController:mana animated:YES];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableArray count];
    
}


@end
