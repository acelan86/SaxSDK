//
//  SaxSplashAdRequester.h
//  SaxSDK
//
//  Created by wuqiang on 14/10/25.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SAXAdResponse.h"

@interface SaxSplashAdRequestManager : NSObject

@property (nonatomic) BOOL testing;
@property (nonatomic,strong) SAXAdResponseContent *responseContent; //cache中的responseContent


-(id) initWithAdunitId:(NSString *)adunitId
                  size:(CGSize)size;

//请求广告
-(void) requestAd;

@end
