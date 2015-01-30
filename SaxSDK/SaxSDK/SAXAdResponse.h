//
//  SAXAdResponse.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-22.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SAXAdResponseContent;

@interface SAXAdResponse : NSObject
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) SAXAdResponseContent *content;

-(id) initWithDictionary:(NSDictionary *)dictionary;
+(BOOL) validateCommon:(id)common;
@end


@interface SAXAdResponseContent : NSObject
@property (nonatomic, strong) NSString *lineitemId; //投放单id
@property (nonatomic, strong) NSArray *src;  //素材
@property (nonatomic, strong) NSArray *type; //素材类型
@property (nonatomic, strong) NSArray *link; //落地页
@property (nonatomic, strong) NSArray *pv;   //曝光监测
@property (nonatomic, strong) NSArray *monitor; //点击监测
@property (nonatomic, strong) NSArray *close; //关闭监测
@property (nonatomic, strong) NSNumber *freq; //广告最大展示次数
@property (nonatomic, strong) NSString *beginTime; //开始时间
@property (nonatomic, strong) NSString *endTime; //结束时间
@end


