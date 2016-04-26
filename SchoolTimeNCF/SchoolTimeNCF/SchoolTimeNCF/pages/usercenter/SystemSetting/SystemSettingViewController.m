//
//  UpdateSystemsViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "SetPassWordViewController.h"
#import "UpdateSystemViewController.h"
#import "LoadDataViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"


@interface SystemSettingViewController ()

@end

@implementation SystemSettingViewController

@synthesize listData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackButton];
    NSArray *array=[[NSArray alloc] initWithObjects:@"修改密码",@"版本选择",@"账户退出",nil];
    self.listData=array;
    self.sysTableView.scrollEnabled=NO;
    [self.sysTableView setFrame:CGRectMake(0, 0, 370, 114)];
    
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


-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.listData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    NSUInteger row=[indexPath row];
    
    cell.textLabel.text=[listData objectAtIndex:row];
    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row==0) {
        SetPassWordViewController* setPWDView=[[SetPassWordViewController alloc]init];
        setPWDView.title=@"修改密码";
        [self.navigationController pushViewController:setPWDView animated:YES];
     }else if (row==1){
         UpdateSystemViewController* updateSystemView=[[UpdateSystemViewController alloc] init];
         updateSystemView.title=@"版本选择";
         [self.navigationController pushViewController:updateSystemView animated:YES];
     }else if (row==2){
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统退出"
                                              message:@"确定退出系统？"
                                             delegate:self
                                    cancelButtonTitle:@"暂不退出"
                                    otherButtonTitles:@"确定退出", nil];
         [alert show];
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
     }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:0 forKey:@"LoginState"];
        [userDefaults synchronize];
        
        
        UINavigationController *navController=[[UINavigationController alloc]init];
        
        LoginViewController *login=[[LoginViewController alloc]init];
        
        [navController pushViewController:login animated:NO];
        
        UIApplication *app =[UIApplication sharedApplication];
        AppDelegate *app2 = app.delegate;
        app2.window.rootViewController = navController;
 
    }
}

/*- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    NSLog(@"willPresentAlertView")
    // 遍历 UIAlertView 所包含的所有控件
    for (UIView *tempView in alertView.subviews) {
        
        if ([tempView isKindOfClass:[UIButton class]]) {
            // 当该控件为一个 UILabel 时
            NSLog(@"Button");
            UIButton *tempButton = (UIButton *) tempView;
            tempButton.titleLabel.textColor=[UIColor blackColor];
          
        }
        
    }
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
