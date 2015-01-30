//
//  SaxSplashAdCacheManager.m
//  SaxSDK
//
//  Created by wuqiang on 14/10/26.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SaxSplashAdCacheUtil.h"
#import "SAXEGOCache.h"

static NSString *const kSplashJsonCacheKey = @"SplashJsonCacheKey";
static NSString *const kSplashImpressionCacheKey = @"kSplashImpressionCacheKey";
static NSString *const kSplashImageCacheKey = @"kSplashImageCacheKey";

@implementation SaxSplashAdCacheUtil

//Json 缓存是否存在
+ (BOOL)hasSplashJsonCache {
    return [[SAXEGOCache globalCache] hasCacheForKey:kSplashJsonCacheKey];
}

//获取json cache
+ (NSData *) splashJsonCache {
    return [[SAXEGOCache globalCache] dataForKey:kSplashJsonCacheKey];
}

//设置json cache
+ (void) setSplashJsonCache:(NSData *)data {
    [[SAXEGOCache globalCache] setData:data forKey:kSplashJsonCacheKey];
}

//清除json cache
+(void) removeSplashJsonCache {
    [[SAXEGOCache globalCache] removeCacheForKey:kSplashJsonCacheKey];
}

/*
 * Image
 */
//image缓存是否存在
+(BOOL) hasSplashImageCache:(NSString *)key {
    return [[SAXEGOCache globalCache] hasCacheForKey:key];
}

//获得image缓存
+(NSData *) splashImageCache:(NSString *)key {
    return [[SAXEGOCache globalCache] dataForKey:key];
}

//设置image缓存
+(void) setSplashImageCache:(NSData *)image forKey:(NSString *)key {
    [[SAXEGOCache globalCache] setData:image forKey:key];
}

//清除image 缓存
+(void) removeSplashImageCache {
    [[SAXEGOCache globalCache] removeCacheForKey:kSplashImageCacheKey];
}

/*
 * Clear
 */
+(void) clearExpireCache {
    [[SAXEGOCache globalCache] clearExpireCache];
}

@end
