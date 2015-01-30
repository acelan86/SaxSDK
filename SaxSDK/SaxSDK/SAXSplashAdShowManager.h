//
//  SAXSplashAdManager.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-24.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SAXAdServerCommunicator.h"
#import "SAXAdResponse.h"




@interface SAXSplashAdShowManager : NSObject

@property (nonatomic,strong) SAXAdResponseContent *responseContent; //cache中的responseContent
@property (nonatomic,strong) NSData *image;

-(id) initWithAdunitId:(NSString *)adunitId
                  size:(CGSize)size;

//初始化
-(BOOL) prepare;

//发送实时曝光监控
-(void) trackImpression;
//点击监控
-(void) trackClick;
//关闭监控
-(void) trackClose;


@end
