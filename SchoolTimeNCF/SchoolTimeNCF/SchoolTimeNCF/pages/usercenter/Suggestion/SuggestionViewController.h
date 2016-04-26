//
//  SuggestionViewController.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/12.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *sugTextView;
@property (weak, nonatomic) IBOutlet UILabel *label;

-(IBAction)submit:(id)sender;
-(IBAction)backgroundTap:(id)sender;
@end
