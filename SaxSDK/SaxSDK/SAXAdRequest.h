//
//  SAXAdRequest.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-22.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAXAdRequest : NSMutableURLRequest

-(id) initPostRequestWithUrl:(NSURL *)url
                     andData:(NSData *)data
             timeoutInterval:(NSTimeInterval)timeInterval;

@end
