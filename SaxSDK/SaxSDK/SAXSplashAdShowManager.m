//
//  SAXSplashAdManager.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-24.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXSplashAdShowManager.h"
#import "SAXAnalyticsTracker.h"
#import "SAXEGOCache.h"
#import "SAXInfoProvider.h"
#import "SAXLogging.h"
#import "SAXAdResponse.h"
#import "SAXNSStringUtil.h"
#import "SaxSplashAdCacheUtil.h"
#import "SaxSplashAdUtil.h"

#define kSaxQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface SAXSplashAdShowManager()
@property (nonatomic, strong) NSString *adunitId;
@property (nonatomic) CGSize size;
@property (nonatomic,strong) NSString *sizeString;


@end

@implementation SAXSplashAdShowManager

@synthesize adunitId = _adunitId;
@synthesize size = _size;

-(id) initWithAdunitId:(NSString *)adunitId size:(CGSize)size {
    self = [super init];
    if (self) {
        self.adunitId = adunitId;
        self.size = size;
        self.sizeString = [NSString stringWithFormat:@"%d*%d",(int)_size.width,(int)_size.height];
    }
    return self;
}

-(BOOL) prepare {
    @try {
        //json 缓存是否不存在的情况
        if (![SaxSplashAdCacheUtil hasSplashJsonCache]) {
            return NO;
        }
        
        SAXAdResponse  *responseObj = [[SAXAdResponse alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:[SaxSplashAdCacheUtil splashJsonCache] options:NSJSONReadingMutableLeaves error:nil]];
        _responseContent = responseObj.content;
        
        NSString *src = [SaxSplashAdUtil selectSuitableSrc:responseObj.content.src size:[NSString stringWithFormat:@"%d*%d",(int)_size.width,(int)_size.height]];
        
        SAXLogDebug(@"Image src: %@", src);
        
        NSString *md5src = [SaxSplashAdUtil MD5Src:src];
        
        [SaxSplashAdCacheUtil removeSplashJsonCache];
        
        //json缓存存在，但是image缓存不存在，这种情况理论上有某种错误出现，简化处理（不下载图片，而是后续完整重新json）
        if (![SaxSplashAdCacheUtil hasSplashImageCache:md5src]) {
            return NO;
        }
        
        _image = [SaxSplashAdCacheUtil splashImageCache:md5src];
        
        return YES;

    }
    @catch (NSException *exception) {
        SAXLogDebug(@"Exception:%@",exception);
        return NO;
    }
}


-(void) trackImpression {
    dispatch_async(kSaxQueue, ^{
        [[SAXAnalyticsTracker tracker] trackUrls:_responseContent.pv];
    });
}

-(void) trackClick {
    dispatch_async(kSaxQueue, ^{
        [[SAXAnalyticsTracker tracker] trackUrls:_responseContent.monitor];
    });
}

-(void) trackClose {
    dispatch_async(kSaxQueue, ^{
        [[SAXAnalyticsTracker tracker] trackUrls:_responseContent.close];
    });
}

-(void) dealloc {
    SAXLogDebug(@"SAXSplashAdShowManager dealloc ...");
}

@end
