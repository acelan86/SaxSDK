//
//  SaxSplashAdCacheManager.h
//  SaxSDK
//
//  Created by wuqiang on 14/10/26.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaxSplashAdCacheUtil : NSObject


/**
 * json
 */

//Json 缓存是否存在
+ (BOOL)hasSplashJsonCache;

//获取json cache
+ (NSData *) splashJsonCache;

//设置json cache
+ (void) setSplashJsonCache:(NSData *)data;

//清除json cache
+(void) removeSplashJsonCache;

/*
 * Image
 */
//image缓存是否存在
+(BOOL) hasSplashImageCache:(NSString *)key;

//获得image缓存
+(NSData *) splashImageCache:(NSString *)key;

//设置image缓存
+(void) setSplashImageCache:(NSData *)image forKey:(NSString *)key;

//清除image 缓存
+(void) removeSplashImageCache;

/*
 * Clear
 */
+(void) clearExpireCache;

@end
