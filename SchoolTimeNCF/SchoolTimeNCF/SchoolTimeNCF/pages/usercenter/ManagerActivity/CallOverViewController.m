//
//  CallOverViewController.m
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/24.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import "CallOverViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HttpGet.h"
#import "UIView+Toast.h"
#import "MyJson.h"
#import "MBProgressHUD.h"
#import "DBHelper.h"

@interface CallOverViewController ()<CLLocationManagerDelegate>{
    double lat;
    double lon;
    NSInteger hour;
    NSInteger  minutes;
    NSInteger tagUpdateLocation;
    NSInteger tagTimeLimite;
}
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation CallOverViewController

@synthesize activityid;
@synthesize orgnization;
@synthesize titl;
@synthesize orgnizationid;
@synthesize contenthtml;
@synthesize attachmentname;
@synthesize titleLabel;
@synthesize geoImage;
@synthesize timeImage;
@synthesize hourText;
@synthesize minText;
@synthesize hourLabel;
@synthesize minuLabel;

- (void)viewDidLoad {
    
    lat=0;
    lon=0;
    hour=0;
    minutes=0;
    tagUpdateLocation=0;
    tagTimeLimite=1;
    
    [super viewDidLoad];
    self.title=@"点名设置";
    [self addBackButton];
    titleLabel.text=titl;
    hourText.text=[NSString stringWithFormat:@"%ld",hour];
    minText.text=[NSString stringWithFormat:@"%ld",minutes];
    
    geoImage.image=[UIImage imageNamed:@"weiqiandao.png"];
    timeImage.image=[UIImage imageNamed:@"weiqiandao.png"];
    
    geoImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getLocation)];
    [geoImage addGestureRecognizer:singleTap];
    
    timeImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *leTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getTimeLimite)];
    [timeImage addGestureRecognizer:leTap];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    hourText.clearsOnBeginEditing=YES;
    minText.clearsOnBeginEditing=YES;
    
}


//- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder


-(IBAction)press:(id)sender{
    
    if(tagUpdateLocation==1){
        
        [self.locationManager stopUpdatingLocation];
    }
    if (tagTimeLimite==0) {
        hour=0;
        minutes=0;
    }else{
        hour=[hourText.text intValue];
        minutes=[minText.text intValue];
        if (hour<0 || hour>69) {
            [self.view makeToast:@"小时的值必须为0～69之间的整数"];
            return;
        }
        if (minutes<0 || minutes>59) {
            [self.view makeToast:@"分钟的值必须为0～59之间的整数"];
            return;
        }
    }
    
    if (tagUpdateLocation==0) {
        if (lat==0.0 || lon==0.0) {
            [self.locationManager stopUpdatingLocation];
        }
        lat=0.0;
        lon=0.0;
    }else{
        if (lat==0.0 || lon==0.0) {
            [self.view makeToast:@"定位失败，请重试，或者不要选择基于地理位置定位的方式"];
            return;
        }
    }
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText=@"正在发起点名，请稍后〜,请稍候！";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *method=@"callover";
        NSString *property=[NSString stringWithFormat:@"activityid=%@&hour=%ld&minute=%ld&localx=%f&localy=%f",activityid,hour,minutes,lat,lon];
        
        NSLog(@"prop: %@", property);
        NSString *httpjson=[HttpGet DoGet:method property:property];
        NSLog(@"httpjson: %@", httpjson);
        if([httpjson isEqualToString:@"ok"]){
            [hud hide:YES];
            [self.view makeToast:@"点名行为发起成功〜"];
            
        }else{
            if([httpjson isEqualToString:@"wrong"]){
                [hud hide:YES];
                [self.view makeToast:@"亲，该活动已经点过名了〜"];
                
            }else{
                [hud hide:YES];
                [self.view makeToast:@"网络连接或其他意外错误"];
            }
        }
    });
}


- (void)getTimeLimite{
    if (tagTimeLimite==1) {
        hour=[hourText.text intValue];
        minutes=[minText.text intValue];
        hourText.hidden=YES;
        minText.hidden=YES;
        hourLabel.hidden=YES;
        minuLabel.hidden=YES;
        [timeImage setImage:[UIImage imageNamed:[self getIcon:1]]];
        tagTimeLimite=0;
    }else{
        hourText.hidden=NO;
        minText.hidden=NO;
        hourLabel.hidden=NO;
        minuLabel.hidden=NO;
        [timeImage setImage:[UIImage imageNamed:[self getIcon:0]]];
        hourText.text=[NSString stringWithFormat:@"%ld",hour];
        minText.text=[NSString stringWithFormat:@"%ld",minutes];
        tagTimeLimite=1;
    }
}

- (void)getLocation
{
    NSLog(@"taglocation=%ld",tagUpdateLocation);
    if (tagUpdateLocation==0) {
       if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
           
           NSLog(@"Local1");
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
           
            [geoImage setImage:[UIImage imageNamed:[self getIcon:1]]];
            tagUpdateLocation=1;
           
        
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
             [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Request" message:@"To use this feature you need to turn on Location Service." delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Go to Settings", nil];
            alert.tag=2;
            [alert show];
        }
        else {
            NSLog(@"Local2");
            [self.locationManager startUpdatingLocation];
            [geoImage setImage:[UIImage imageNamed:[self getIcon:1]]];
            tagUpdateLocation=1;
            
        }
    }else{
        [geoImage setImage:[UIImage imageNamed:[self getIcon:0]]];
        [self.locationManager stopUpdatingLocation];
        tagUpdateLocation=0;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"open the loca");
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    lat=currLocation.coordinate.latitude;
    lon=currLocation.coordinate.longitude;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    NSLog(@"%@", visit);
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


-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)goBackAction{
    if(tagUpdateLocation==1){
        
        [self.locationManager stopUpdatingLocation];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getIcon:(NSInteger)state{
    
    
    if(state==0){
        return @"weiqiandao.png";
    }else{
        return @"yiqiandao.png";
    }
    
    return @"yiqiandao.png";
    
}

-(IBAction)backgroundTap:(id)sender
{
        [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
