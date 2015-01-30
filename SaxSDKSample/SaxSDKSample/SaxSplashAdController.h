//
//  SaxSplashController.h
//  SaxSDK
//
//  Created by wuqiang on 14/10/27.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SAX_SPLASH_SIZE_IPHONE4     CGSizeMake(320, 480)
#define SAX_SPLASH_SIZE_IPHONE5     CGSizeMake(320, 568)
#define SAX_SPLASH_SIZE_IPAD        CGSizeMake(768, 576)
#define SAX_SPLASH_SIZE_NOT_SUPPORT CGSizeMake(0,0)

@protocol SaxSplashAdControllerDelegate;

@interface SaxSplashAdController : NSObject

@property (nonatomic,weak) id<SaxSplashAdControllerDelegate> delegate;

-(void) present:(NSString *)adposId
     background:(UIColor *)bgColor
           size:(CGSize)size
         offset:(CGFloat)offset
        browser:(BOOL)isUserDefine;

+(BOOL) shouldShowAd:(CGSize)size;
+(void) requestAd:(NSString *)adposId size:(CGSize)size testing:(BOOL)isTesting;
+(void) requestAd:(NSString *)adposId size:(CGSize)size;
@end

@protocol SaxSplashAdControllerDelegate<NSObject>

-(void)saxSplashAdTimeout;

-(void)saxSplashAdWillPresentScreenBackFromBrowser;

-(void)saxSplashAdShowError;

//使用自定义浏览器打开
-(void)saxSplashAdBrowerOpenWithUserBrowser:(NSString *)url adViewController:(UIViewController *)controller;


@end
