//
//  SAXInfoProvider.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-19.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class SAXIdentity;

@interface SAXInfoProvider : NSObject

+(SAXInfoProvider *)shareInstance;

//设备类型
-(NSString *)deviceType;

//OS版本
-(NSString *)osVersion;

// 唯一身份标识
-(SAXIdentity *)identifier;

//MAC地址
-(NSString *)macAddress;

//md5后的MAC地址
-(NSString *)md5MacAddress;

//屏幕尺寸
-(CGSize) screenSize;

//分辨率
-(NSString *)resolution;

//屏幕朝向
-(UIInterfaceOrientation) orientation;

//BundleIdentifier
-(NSString *)bundleIdentifier;

//是否能联网
//-(BOOL)isConnectionRequired;

//网络类型
-(NSInteger)networkType;

//app版本
-(NSString *)appVersion;

//电信运营商
-(NSString *)carrierName;

//BuildUrl
- (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)URL;

//UA
- (NSString *)userAgent;

@end


/**
 * 身份唯一标示符
 */
@interface SAXIdentity : NSObject
@property (nonatomic,strong,readonly) NSString *type;
@property (nonatomic,strong,readonly) NSString *value;

-(SAXIdentity *)initWithType:(NSString *)type andValue:(NSString *)value;
@end
