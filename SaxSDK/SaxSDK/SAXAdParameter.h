//
//  SAXAdParameter.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-21.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kSAXAdParameterTypeNone = 0,    //未设置
    kSAXAdParameterTypeString,      //参数为字符串类型
    kSAXAdParameterTypeNumber,      //参数为数字类型
    kSAXAdParameterTypeDictionary,  //参数为字典类型
    kSAXAdParameterTypeArray,
} kSAXAdParameterType;

@interface SAXAdParameter : NSObject
@property (nonatomic) BOOL required;
@property (nonatomic, strong) NSString *key; //参数key
@property (nonatomic) kSAXAdParameterType parameterType; //参数类型
@property (nonatomic, strong) NSString *parameterString; //参数是string
@property (nonatomic, strong) NSNumber *parameterNumber; //参数是Number
@property (nonatomic, strong) NSDictionary *parameterDictionary; //参数为dictionary
@property (nonatomic, strong) NSArray *parameterArray; //参数是array

//获取拼接的参数
-(NSString *) getUrlParameterString;
@end
