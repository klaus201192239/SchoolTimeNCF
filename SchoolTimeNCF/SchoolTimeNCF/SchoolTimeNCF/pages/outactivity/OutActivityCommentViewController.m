//
//  OutActivityCommentViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/19.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "OutActivityCommentViewController.h"
#import "InActivityCommentHeader.h"
#import "ImageDownLoad.h"
#import "Util.h"
#import "HttpGet.h"
#import "InActivityCommentItemCell.h"
#import "MyJson.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "OutActivityViewController.h"
#import "OutActivityDetailViewController.h"

@interface OutActivityCommentViewController (){
   
    NSMutableArray *commentArray;
    
    //NSInteger changeTag;
    
    NSInteger newCommentNum;
    
}

@end

@implementation OutActivityCommentViewController

@synthesize activityid;
@synthesize from;
@synthesize title;
@synthesize imgurl;
@synthesize category;
@synthesize deadline;
@synthesize time;
//@synthesize indexOfArray;

@synthesize myTableView;
@synthesize inputComment;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"所有评论";//by lily
    newCommentNum=0;
    
    
    [self AddNavigationBack];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    inputComment.delegate=self;
    
    //changeTag=0;
    
    commentArray=[[NSMutableArray alloc]init];
    [commentArray addObject:@"评论信息"];
    
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.navigationItem.title = @"所有评论";//by lily
    
    
    [self AddNavigationBack];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在获取活动的评论信息,请稍候！";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        [self getNetData];
        
        [hud hide:YES];
        
        [myTableView reloadData];
        
        
    });

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)uploadComment:(id)sender{
    
    newCommentNum++;
    
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [inputComment resignFirstResponder];
    
    
    NSString * str=inputComment.text;
    
    if(str.length==0){
        [self.view makeToast:@"请输入内容哦〜〜"];
    }else{
        
        [commentArray addObject:inputComment.text];
        
        [myTableView reloadData];
        
        inputComment.text=@"";
        
        [self.view makeToast:@"发表成功"];
        
        //changeTag++;
        
        [NSThread detachNewThreadSelector:@selector(uploadCommmentToServer:) toTarget:self withObject:str];
        
    }


}

-(void)uploadCommmentToServer:(id)sender{
    
    NSString *com=(NSString *)sender;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid=[userDefaults objectForKey:@"Id"];
    
    NSString *method=@"addcomment";
    NSString *property=[NSString stringWithFormat:@"activityid=%@&userid=%@&activitytype=1&comment=%@",activityid,userid,[Util encodeString:com]];
    
    [HttpGet DoGet:method property:property];
    
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
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    
    if([from isEqualToString:@"013"]){
        
        OutActivityViewController *activity=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        
        if(newCommentNum>0){
            
            activity.changeTag=1;
            activity.commentChange=newCommentNum;
            
            
        }else{
            
            
            activity.changeTag=0;
            
        }

        activity.currentActivityId=activityid;
        
        [self.navigationController popToViewController:activity animated:TRUE];
        
        
    }else{
        
        OutActivityDetailViewController *activity=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        
        if(newCommentNum>0){
            
            activity.changeTag=1;
            activity.commentChange=newCommentNum;
            
        }else{
            
            
            activity.changeTag=0;
            
        }

        
        [self.navigationController popToViewController:activity animated:TRUE];
        
    }

    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(section==0){
        return 1;
    }else{
        return [commentArray count];
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        static NSString *simpleTableIdentifier = @"InActivityCommentHeader";
        
        InActivityCommentHeader *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityCommentHeader" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.title.text=title;
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
        
        return cell;
    }else{
        
        static NSString *simpleTableIdentifier = @"InActivityCommentItemCell";
        
        InActivityCommentItemCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InActivityCommentItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSInteger indexImg = ((indexPath.row+1) % 9)+1;
        
        [cell.imgage setImage:[UIImage imageNamed:[NSString stringWithFormat: @"commentni%ld.png",indexImg]]];
        
        cell.floor.text=[NSString stringWithFormat:@"%ld楼童鞋",indexPath.row+1];
        
        cell.content.text=[commentArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去掉所选择的行的高亮状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 289;
    }else{
        return 73;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [inputComment resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGFloat keyboardHeight = 286.0f;
    
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height-keyboardHeight - textField.frame.size.height - 5);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}


-(BOOL)textField:( UITextField  *)textField shouldChangeCharactersInRange:( NSRange )range replacementString:(NSString  *)string{
    
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            [self.view makeToast:@"暂时不支持表情输入哦～～"];
            
            return NO;
        }
    }
    
    return YES;
    
}


-(void)getNetData{

    
    NSString *method=@"getcomment";
    NSString *property=[NSString stringWithFormat:@"activityid=%@&activitytype=1",activityid];
    
    NSString *httpjso=[HttpGet DoGet:method property:property];
    
    if([httpjso isEqualToString:@"error"]){
        
        
    }else{
        
        NSMutableArray *array=[MyJson JsonSringToArray:httpjso];
        
        [commentArray removeAllObjects];
        
        for(int i=0;i<[array count];i++){
            
            NSDictionary *dic=[array objectAtIndex:i];
            
            [commentArray addObject:[dic objectForKey:@"comment"]];
            
        }
        
    }
}

@end
