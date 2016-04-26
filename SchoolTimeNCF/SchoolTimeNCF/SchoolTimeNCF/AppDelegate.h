//
//  AppDelegate.h
//  SchoolTimeNCF
//
//  Created by OurEDA on 15/12/3.
//  Copyright (c) 2015年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *hostReach;
}
@property (strong, nonatomic) UIWindow *window;

- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变

- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接改变后的情况


@end

