//
//  SAXAdParameterBuilder.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-21.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXAdParameterBuilder.h"
#import "SAXAdParameter.h"
#import "SAXAdRequestKeys.h"
#import "SAXInfoProvider.h"
#import "SAXLogging.h"
#import "SAXNSStringUtil.h"
#import "SaxContants.h"

@implementation SAXAdParameterBuilder

@synthesize adunitId = _adunitId;
@synthesize size = _size;
@synthesize rotateCount = _rotateCount;
//@synthesize timestamp = _timestamp;
@synthesize deviceId = _deviceId;
@synthesize devicePlatform = _devicePlatform;
@synthesize deviceType = _deviceType;
@synthesize carrier = _carrier;
@synthesize client = _client;
@synthesize intra = _intra;
@synthesize targeting = _targeting;

-(NSString *)urlWithAdunitId:(NSString *)adUnitId size:(NSString *)size rotate:(NSInteger)rotate andTimestamp:(NSString *)timestamp {
    
    //设置输入变量
    self.adunitId.parameterArray = [NSArray arrayWithObject:adUnitId];
    self.size.parameterArray = [NSArray arrayWithObject:size];
    self.rotateCount.parameterNumber = [NSNumber numberWithInteger:rotate];
    
    //设置timestamp
//    SAXAdParameter *timeStamp = [[SAXAdParameter alloc] init];
//    timeStamp.required = YES;
//    timeStamp.key = SAXAdRequestKeysTimeStamp;
//    timeStamp.parameterString = timestamp;
    
    //拼接参数
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    [paramsString appendString:@"{"];
    [self addUrlParameter:paramsString withparameter:self.adunitId];
    [self addUrlParameter:paramsString withparameter:self.size];
    [self addUrlParameter:paramsString withparameter:self.rotateCount];
//    [self addUrlParameter:paramsString withparameter:timeStamp];
    [self addUrlParameter:paramsString withparameter:self.deviceId];
    [self addUrlParameter:paramsString withparameter:self.devicePlatform];
    [self addUrlParameter:paramsString withparameter:self.deviceType];
    [self addUrlParameter:paramsString withparameter:self.carrier];
    [self addUrlParameter:paramsString withparameter:self.client];
    [self addUrlParameter:paramsString withparameter:self.intra];
    [self addUrlParameter:paramsString withparameter:self.targeting];
    
    [paramsString appendString:@"}"];
    
    SAXLogDebug(@"Post Json: %@", paramsString);
    return paramsString;
}


-(SAXAdParameter *)adunitId {
    if(!_adunitId) {
        _adunitId = [[SAXAdParameter alloc] init];
        _adunitId.required = YES;
        _adunitId.key = SAXAdRequestKeysAdunitId;
    }
    return _adunitId;
}

-(SAXAdParameter *)size {
    if(!_size) {
        _size = [[SAXAdParameter alloc] init];
        _size.required = YES;
        _size.key = SAXAdRequestKeysSize;
    }
    return _size;
}

-(SAXAdParameter *)rotateCount {
    if (!_rotateCount) {
        _rotateCount = [[SAXAdParameter alloc] init];
        _rotateCount.required = NO;
        _rotateCount.key = SAXAdRequestKeysRotateCount;
        _rotateCount.parameterNumber = [[NSNumber alloc] initWithInteger: arc4random() % 100];
    }
    return _rotateCount;
}


-(SAXAdParameter *)deviceId {
    if (!_deviceId) {
        _deviceId = [[SAXAdParameter alloc] init];
        _deviceId.required = NO;
        _deviceId.key = SAXAdRequestKeysDeviceId;
        _deviceId.parameterString = [SAXNSStringUtil stringToMd5:[[[SAXInfoProvider shareInstance] identifier] value]];
    }
    return _deviceId;
}

-(SAXAdParameter *)devicePlatform {
    if (!_devicePlatform) {
        _devicePlatform = [[SAXAdParameter alloc] init];
        _devicePlatform.required = NO;
        _devicePlatform.key = SAXAdRequestKeysDevicePlatform;
        _devicePlatform.parameterString = @"1"; //0:unknown, 1:phone, 2:tablet
//        _devicePlatform.parameterString = [[SAXInfoProvider shareInstance] deviceType];
        
        
    }
    return _devicePlatform;
}

-(SAXAdParameter *)deviceType {
    if (!_deviceType) {
        _deviceType = [[SAXAdParameter alloc] init];
        _deviceType.required = NO;
        _deviceType.key = SAXAdRequestKeysDeviceType;
//        _deviceType.parameterString = [[SAXInfoProvider shareInstance] deviceType];
        _deviceType.parameterString = @"1"; //0:unknown, 1:phone, 2:tablet 暂时只有手机
    }
    return _deviceType;
}

-(SAXAdParameter *)carrier {
    if (!_carrier) {
        _carrier = [[SAXAdParameter alloc] init];
        _carrier.required = NO;
        _carrier.key = SAXAdRequestKeysCarrier;
        _carrier.parameterNumber = [[NSNumber alloc] initWithInteger:[[SAXInfoProvider shareInstance] networkType]];
    }
    return _carrier;
}

-(SAXAdParameter *)client {
    if (!_client) {
        _client = [[SAXAdParameter alloc] init];
        _client.required = NO;
        _client.key = SAXAdRequestKeysClient;
//        _client.parameterString = @"sportapp";
        _client.parameterString = [[SAXInfoProvider shareInstance] bundleIdentifier];
    }
    return _client;
}

-(SAXAdParameter *)intra {
    if (!_intra) {
        _intra = [[SAXAdParameter alloc] init];
        _intra.required = NO;
        _intra.key = SAXAdRequestKeysIntra;
    }
    return _intra;
}

-(SAXAdParameter *) targeting {
    if (!_targeting) {
        _targeting = [[SAXAdParameter alloc] init];
        _targeting.required = NO;
        _targeting.key = SAXAdRequestKeysTargeting;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:SAX_SDK_VERSION forKey:@"sdk_version"];
        _targeting.parameterDictionary = params;
    }
    return _targeting;
}

- (void)addUrlParameter:(NSMutableString *)mutableString withparameter:(SAXAdParameter *)parameter {
    NSString *urlParameter = [parameter getUrlParameterString];
    if ([urlParameter length] < 1) {
        return;
    }
    if ([mutableString length] < 2) {
        [mutableString appendString:urlParameter];
    }
    else {
        [mutableString appendString:@","];
        [mutableString appendString:urlParameter];
    }
}


@end
