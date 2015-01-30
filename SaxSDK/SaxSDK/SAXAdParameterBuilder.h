//
//  SAXAdParameterBuilder.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-21.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAXAdParameter.h"

@interface SAXAdParameterBuilder : NSObject

@property(nonatomic,strong) SAXAdParameter *adunitId;
@property(nonatomic,strong) SAXAdParameter *size;
@property(nonatomic,strong) SAXAdParameter *rotateCount;
//@property(nonatomic,strong) SAXAdParameter *timestamp;
@property(nonatomic,strong,readonly) SAXAdParameter *deviceId;
@property(nonatomic,strong,readonly) SAXAdParameter *devicePlatform;
@property(nonatomic,strong,readonly) SAXAdParameter *deviceType;
@property(nonatomic,strong,readonly) SAXAdParameter *carrier;
@property(nonatomic,strong,readonly) SAXAdParameter *client;
@property(nonatomic,strong) SAXAdParameter *intra;
@property(nonatomic,strong) SAXAdParameter *targeting;


-(NSString *)urlWithAdunitId:(NSString *)adUnitId
                        size:(NSString *)size
                      rotate:(NSInteger)rotate
                andTimestamp:(NSString *)timestamp;


@end
