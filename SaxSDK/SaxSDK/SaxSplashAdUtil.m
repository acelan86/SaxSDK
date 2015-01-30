//
//  SaxSplashAdUtil.m
//  SaxSDK
//
//  Created by wuqiang on 14/10/26.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SaxSplashAdUtil.h"
#import "SAXNSStringUtil.h"
#import "SaxSplashAdCacheUtil.h"
#import "SAXAdResponse.h"
#import "SAXLogging.h"
#import "SAXReachability.h"

@implementation SaxSplashAdUtil

+(NSString *) MD5Src:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    return [SAXNSStringUtil stringToMd5:str];
}

+(NSString *) selectSuitableSrc:(NSArray *)src size:(NSString *)size {
    if ( src == nil || [src count] == 0 || size == nil) {
        return nil;
    }
    NSString *imageSrc = nil;
    //iphone4获取第一个素材
    if ([@"320*480" isEqualToString:size] && [src count] >= 1 && ![@"" isEqualToString:[src objectAtIndex:0]]) {
        imageSrc = [src objectAtIndex:0];
    }else if([@"320*568" isEqualToString:size] && [src count] >= 2 && ![@"" isEqualToString:[src objectAtIndex:1]]) {
        imageSrc = [src objectAtIndex:1];
    }
    
    return imageSrc;
}


+(NSData *) adImage:(CGSize) size {
    //json 缓存是否不存在的情况
    if (![SaxSplashAdCacheUtil hasSplashJsonCache]) {
        return nil;
    }
    
    SAXAdResponse  *responseObj = [[SAXAdResponse alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:[SaxSplashAdCacheUtil splashJsonCache] options:NSJSONReadingMutableLeaves error:nil]];

    NSString *src = [SaxSplashAdUtil selectSuitableSrc:responseObj.content.src size:[NSString stringWithFormat:@"%d*%d",(int)size.width,(int)size.height]];
    
    SAXLogDebug(@"Image src: %@", src);
    
    NSString *md5src = [SaxSplashAdUtil MD5Src:src];
    
    //json缓存存在，但是image缓存不存在，这种情况理论上有某种错误出现，简化处理（不下载图片，而是后续完整重新json）
    if (![SaxSplashAdCacheUtil hasSplashImageCache:md5src]) {
        return nil;
    }
    
    return [SaxSplashAdCacheUtil splashImageCache:md5src];

}



@end
