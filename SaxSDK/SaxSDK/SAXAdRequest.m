//
//  SAXAdRequest.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-22.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXAdRequest.h"

@implementation SAXAdRequest

-(id)initPostRequestWithUrl:(NSURL *)url andData:(NSData *)data timeoutInterval:(NSTimeInterval)timeInterval{
    self = [super initWithURL:url];
    [self addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self setHTTPMethod:@"POST"];
    [self setTimeoutInterval:timeInterval];
    [self setHTTPBody:data];
    return self;
}

@end
