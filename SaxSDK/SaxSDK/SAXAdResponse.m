//
//  SAXAdResponse.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-22.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXAdResponse.h"
#import "SAXAdResponseKeys.h"
#import "SAXLogging.h"

@implementation SAXAdResponse

@synthesize id = _id;
@synthesize content = _content;

#pragma mark public

/** 这里根据现有的接口特殊处理成对象，后续转换为通用的json转对象方法*/
-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        if (![self p_validateAd:dictionary]) {
            return nil;
        }
        
        //ads为大于1的数组，肯定可以取第一个值
        NSDictionary *ad =  [(NSArray *)[dictionary objectForKey:SAXAdResponseKeysAd] objectAtIndex:0];
        
        NSArray *contentArray = (NSArray *)[ad objectForKey:SAXAdResponseKeysContent];
        
        if (![self p_validateContent:contentArray]) {
            return nil;
        }
        
        self.id = (NSString *)[ad objectForKey:SAXAdResponseKeysId];
        
        SAXAdResponseContent *content = [[SAXAdResponseContent alloc] init];
        
        //contentArray经过验证，count > 0
        NSDictionary *con = [contentArray objectAtIndex:0];
        
        content.lineitemId = [con objectForKey:SAXAdResponseKeysLineitemId];
        content.src = [con objectForKey:SAXAdResponseKeysSrc];
        content.type = [con objectForKey:SAXAdResponseKeysType];
        content.link = [con objectForKey:SAXAdResponseKeysLink];
        content.monitor = [con objectForKey:SAXAdResponseKeysMonitor];
        content.pv = [con objectForKey:SAXAdResponseKeysPv];
        content.close = [con objectForKey:SAXAdResponseKeysClose];
        content.freq = [con objectForKey:SAXAdResponseKeysFreq];
        content.beginTime = [con objectForKey:SAXAdResponseKeysBeginTime];
        content.endTime = [con objectForKey:SAXAdResponseKeysEndTime];
        
        self.content = content;
        
        if (![self p_validateSrc:content.src]) {
            return nil;
        }
        
    }
    return self;
}


#pragma mark private

-(BOOL) p_validateAd: (NSDictionary *)dictionary {
    
    NSArray *ads = (NSArray*)[dictionary objectForKey:SAXAdResponseKeysAd];
    //1. 返回{}时，ads为nil
    //2. 返回"ad": []时，count == 0
    //3. 返回ad == null， ads == (id)[NSNull null]
    if (![SAXAdResponse validateCommon:ads]) {
        return NO;
    }
    return YES;
}

-(BOOL) p_validateContent:(NSArray *)contents {
    //1. {"ad":[{}]}, content == nil
    //2. {"ad":[{"content":[]}]}, content.count == 0
    //3. 返回{"ad":[{"content":null}]}， contents == (id)[NSNull null]
    if ( ![SAXAdResponse validateCommon:contents] ) {
        return NO;
    }
    return YES;
}

-(BOOL) p_validateSrc:(NSArray *)src {
    if (![SAXAdResponse validateCommon:src]) {
        return NO;
    }
    return YES;
}

+(BOOL) validateCommon:(id)common {
    if (common == nil) {
        return NO;
    }
    if (common == (id)[NSNull null]) {
        return NO;
    }
    if ([common isKindOfClass:[NSArray class]]) {
        return ((NSArray *)common).count != 0;
    }
    return YES;
}


@end


@implementation SAXAdResponseContent
@synthesize lineitemId = _lineitemId;
@synthesize src = _src;
@synthesize type = _type;
@synthesize link = _link;
@synthesize pv = _pv;
@synthesize monitor = _monitor;
@synthesize close = _close;
@synthesize freq = _freq;
@synthesize beginTime = _beginTime;
@synthesize endTime = _endTime;

@end
