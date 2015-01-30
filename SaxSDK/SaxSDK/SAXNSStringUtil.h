//
//  NSStringUtil.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-19.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAXNSStringUtil : NSObject
+(NSString *)stringToMd5:(NSString *)aString;
+(NSString *) trim:(NSString *)str;
+(BOOL) notEmpty:(NSString *)str;
@end
