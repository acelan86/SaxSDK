//
//  SAXAdResponseKeys.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-22.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const SAXAdResponseKeysAd; //广告

extern NSString *const SAXAdResponseKeysId; //pdps
extern NSString *const SAXAdResponseKeysContent; //广告数据

extern NSString *const SAXAdResponseKeysLineitemId; //
extern NSString *const SAXAdResponseKeysSrc; //广告素材
extern NSString *const SAXAdResponseKeysType; //素材类型
extern NSString *const SAXAdResponseKeysLink; //落地页
extern NSString *const SAXAdResponseKeysPv; //曝光监测
extern NSString *const SAXAdResponseKeysMonitor;   //点击监测
extern NSString *const SAXAdResponseKeysClose; //关闭监测
extern NSString *const SAXAdResponseKeysFreq; //广告最大展示次数
extern NSString *const SAXAdResponseKeysBeginTime; //开始时间
extern NSString *const SAXAdResponseKeysEndTime; //结束时间


@interface SAXAdResponseKeys : NSObject


@end
