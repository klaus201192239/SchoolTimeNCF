//
//  UpdateSystemViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateSystemViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nowVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsVersionLabel;

@property(nonatomic,retain) NSString *nowVersion;
@property(nonatomic,retain) NSString *eVersion;
@property(nonatomic,retain) NSString *goodsVersion;

-(IBAction)update:(id)sender;

@end
