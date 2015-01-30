//
//  SAXAnalyticsTracker.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-24.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAXAnalyticsTracker : NSObject

+(SAXAnalyticsTracker *)tracker;

-(void) trackUrls:(NSArray *)urls;

@end
