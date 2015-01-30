//
//  NSStringUtil.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-19.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXNSStringUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SAXNSStringUtil

+(NSString *) stringToMd5:(NSString *)aString {
    if(aString == nil || [aString length] == 0)
        return nil;
    
    const char *value = [aString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+(NSString *) trim:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(BOOL) notEmpty:(NSString *)str{
    if ([SAXNSStringUtil trim:str].length != 0) {
        return YES;
    }
    
    return NO;
}

@end
