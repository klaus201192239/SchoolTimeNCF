//
//  ImageDownLoad.m
//  SchoolTimeN
//
//  Created by OurEDA on 15/12/3.
//  Copyright (c) 2015年 Klausllt. All rights reserved.
//

#import "ImageDownLoad.h"
#import "UIImageView+WebCache.h"

@implementation ImageDownLoad


+(void)setImageDownLoad:(UIImageView *)imageview Url:(NSString *)imgWebUrl{
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:imgWebUrl] placeholderImage:[UIImage imageNamed:@"showme.png"]];
    
}


@end
