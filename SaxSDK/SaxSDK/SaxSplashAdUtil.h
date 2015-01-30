//
//  SaxSplashAdUtil.h
//  SaxSDK
//
//  Created by wuqiang on 14/10/26.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaxSplashAdUtil : NSObject

//选择合适的图片，iphone4获取第一个，iphone5获取第二个
+(NSString *) selectSuitableSrc:(NSArray *)src size:(NSString *)size;

//md5
+(NSString *) MD5Src:(NSString *)str;

//获取adImage
+(NSData *) adImage:(CGSize) size;


@end
