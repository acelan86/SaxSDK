//
//  SaxSplashAdRequester.m
//  SaxSDK
//
//  Created by wuqiang on 14/10/25.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SaxSplashAdRequestManager.h"
#import "SAXDateUtil.h"
#import "SaxContants.h"
#import "SAXAdParameterBuilder.h"
#import "SAXAdRequest.h"
#import "SAXAdResponse.h"
#import "SAXAnalyticsTracker.h"
#import "SAXEGOCache.h"
#import "SAXNSStringUtil.h"
#import "SAXLogging.h"
#import "SaxSplashAdCacheUtil.h"
#import "SaxSplashAdUtil.h"

static const NSTimeInterval kRequestTimeoutInterval = 15.0;


@interface SaxSplashAdRequestManager()
@property (nonatomic, strong) NSString *adunitId;
@property (nonatomic) CGSize size;
@property (nonatomic,strong) NSString *sizeString;

@end

@implementation SaxSplashAdRequestManager

@synthesize testing = _testing;

-(id) initWithAdunitId:(NSString *)adunitId size:(CGSize)size {
    self = [super init];
    if (self) {
        self.adunitId = adunitId;
        self.size = size;
        self.testing = NO;
        self.sizeString = [self p_toStringSize:size];
    }
    return self;
}



-(void) requestAd {
    [self loadAdwithAdunitId:_adunitId size:_sizeString rotate:arc4random() / 1000000 andTimeStramp: [NSString stringWithFormat:@"%lld", [SAXDateUtil now]] testing:_testing];
}

-(void) loadAdwithAdunitId:(NSString *)adunitId size:(NSString *)size rotate:(NSInteger)rotate andTimeStramp:(NSString *)timestamp testing:(BOOL)testing{

    NSString *dataStr = [[SAXAdParameterBuilder alloc] urlWithAdunitId:adunitId size:size rotate:rotate andTimestamp:timestamp];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://%@/mobile/impress",testing ? SAX_HOST_TESTING : SAX_HOST_ONLINE];
    SAXLogDebug(@"url:%@", url);
    
    NSData *received = [NSURLConnection sendSynchronousRequest:[self p_adRequestForURL:[NSURL URLWithString:url] andData:data] returningResponse:nil error:nil];
    
    if (received == nil) {
        return;
    }
    
    SAXAdResponse *responseObj = [[SAXAdResponse alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil]];
    
    //返回json无法正确解析或者content为空，直接返回
    if(responseObj == nil || responseObj.content == nil) {
        return;
    }
    
    //content, src验证过，其他的都没有
    SAXAdResponseContent *content = responseObj.content;
    
    SAXLogDebug(@"Get response content: %@", content);
    //缓存data
    [SaxSplashAdCacheUtil setSplashJsonCache:received];
    
    NSString *src = [SaxSplashAdUtil selectSuitableSrc:content.src size:_sizeString];
    
    if (src != nil) {
        NSString *md5src = [SaxSplashAdUtil MD5Src:src];
        
        //查看图片是否有缓存, 如果没有，请求图片并缓存;
        if (![SaxSplashAdCacheUtil hasSplashImageCache:md5src]) {
            NSData *image = [self p_requestImage:src];
            if (image != nil) {
                [SaxSplashAdCacheUtil setSplashImageCache:image forKey:md5src];
            }else {
                //如果请求图片失败，直接清除json缓存，便于下次开屏请求广告，减少一次清理缓存的过程；
                [SaxSplashAdCacheUtil removeSplashJsonCache];
            }
        }else {
            NSData *image = [SaxSplashAdCacheUtil splashImageCache:md5src];
            if (image != nil) {
                [SaxSplashAdCacheUtil setSplashImageCache:image forKey:md5src];
            }
        }
    }

    
}

-(void) dealloc {
    SAXLogDebug(@"SaxSplashAdRequestManager dealloc ...");
}


#pragma private

- (NSURLRequest *)p_adRequestForURL:(NSURL *)URL andData:(NSData *)data {
    SAXAdRequest *request = [[SAXAdRequest alloc] initPostRequestWithUrl:URL andData:data timeoutInterval:kRequestTimeoutInterval];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return request;
}

-(NSData *) p_requestImage:(NSString *)imageUrl {
    NSString* encodedString = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
}

-(NSString *) p_toStringSize:(CGSize)size {
    return [NSString stringWithFormat:@"%d*%d",(int)_size.width,(int)_size.height];
}

@end
