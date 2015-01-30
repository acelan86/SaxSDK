//
//  SAXAdParameter.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-21.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXAdParameter.h"
#import "SAXLogging.h"

@interface SAXAdParameter()


@end

@implementation SAXAdParameter

@synthesize required = _required;
@synthesize key = _key;
@synthesize parameterString = _parameterString;
@synthesize parameterNumber = _parameterNumber;
@synthesize parameterDictionary = _parameterDictionary;

-(void) setParameterNumber:(NSNumber *)parameterNumber {
    if(parameterNumber == nil) {
        SAXLogDebug(@"parameter must not be nil.");
    }
    _parameterNumber = parameterNumber;
    _parameterType = kSAXAdParameterTypeNumber;
}

-(void) setParameterString:(NSString *)parameterString {
    if(parameterString == nil) {
        SAXLogDebug(@"parameter must not be nil.");
    }
    _parameterString = parameterString;
    _parameterType = kSAXAdParameterTypeString;
}

-(void) setParameterDictionary:(NSDictionary *)parameterDictionary {
    if(parameterDictionary == nil ) {
        SAXLogDebug(@"parameter must not be nil.");
    }
    _parameterDictionary = parameterDictionary;
    _parameterType = kSAXAdParameterTypeDictionary;
}

-(void) setParameterArray:(NSArray *)parameterArray {
    if (parameterArray == nil) {
        SAXLogDebug(@"parameter must not be nil.");
    }
    _parameterArray = parameterArray;
    _parameterType = kSAXAdParameterTypeArray;
    
}

//获取拼接的参数
-(NSString *)getUrlParameterString {
    
    if(self.parameterType == kSAXAdParameterTypeNone && self.required == YES) {
        SAXLogDebug(@"type must be set");
        return nil;
    }
    
    //没有参数值，返回空串
    if(!kSAXAdParameterTypeString && !kSAXAdParameterTypeNumber && !kSAXAdParameterTypeDictionary ) {
        return @"";
    }
    
    NSString *urlString = nil;
    
    if(self.parameterType == kSAXAdParameterTypeNumber && self.key != nil) {
        urlString = [NSString stringWithFormat:@"\"%@\":%@",self.key, self.parameterNumber];
    }else if(self.parameterType == kSAXAdParameterTypeString && self.key != nil) {
        urlString = [NSString stringWithFormat:@"\"%@\":\"%@\"",self.key, self.parameterString];
    }else if(self.parameterType == kSAXAdParameterTypeDictionary) {
        NSMutableString *parameters = [[NSMutableString alloc] initWithFormat:@"\"%@\":{", self.key];
        NSArray *keys = [_parameterDictionary allKeys];
        for (int i = 0;i < [keys count];i++) {
            NSString *key  = [keys objectAtIndex:i];
            NSString *parameter = [_parameterDictionary objectForKey:key];
            NSString *aParameter = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,parameter];
            [parameters appendString:aParameter];
            if (i != [keys count] - 1) {
                [parameters appendString:@","];
            }
        }
        urlString = [parameters description];
        [parameters appendString:@"}"];
    }else if(self.parameterType == kSAXAdParameterTypeArray) {
        NSMutableString *parameters = [[NSMutableString alloc] initWithFormat:@"\"%@\":\[",self.key];
        [self.parameterArray enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL *stop) {
            NSString *aParameter = [NSString stringWithFormat:@"\"%@\"", param];
            [parameters appendString:aParameter];
            if (idx != self.parameterArray.count - 1) {
                [parameters appendString:@","];
            }
        }];
        [parameters appendString:@"]"];
        urlString = parameters;
        
    }
    
    return urlString;
}

-(NSString *)description {
    return [self getUrlParameterString];
}

@end
