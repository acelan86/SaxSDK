//
//  SAXDateUtil.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-22.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXDateUtil.h"

@implementation SAXDateUtil

+(long long)now {
    return [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] longLongValue];
}

@end
