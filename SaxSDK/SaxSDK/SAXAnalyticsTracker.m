//
//  SAXAnalyticsTracker.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-24.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXAnalyticsTracker.h"
#import "SAXLogging.h"
#import "SAXAdResponse.h"

static const NSTimeInterval kTrackTimeoutInterval = 15.0f;


@implementation SAXAnalyticsTracker

#pragma mark public

+(SAXAnalyticsTracker *)tracker {
    return [[SAXAnalyticsTracker alloc] init];
}

-(void) trackUrls:(NSArray *)urls {
    if ([SAXAdResponse validateCommon:urls]) {
        [urls enumerateObjectsUsingBlock:^(NSString* url, NSUInteger idx, BOOL *stop) {
            SAXLogDebug(@"Send Request to URL: %@", url);
            [NSURLConnection connectionWithRequest:[self requestUrl:url] delegate:nil];
        }];
    }
}

#pragma mark private

-(NSURLRequest *)requestUrl:(NSString *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request setHTTPShouldHandleCookies:YES];
    request.timeoutInterval = kTrackTimeoutInterval;
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    return request;
    
}

@end
