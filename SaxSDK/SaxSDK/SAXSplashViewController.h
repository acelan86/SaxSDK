//
//  SAXSplashViewController.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-17.
//  Copyright (c) 2014年 ad. All rights reserved.
//
#import "SAXSCGIFImageView.h"
#import <UIKit/UIKit.h>

#define SAX_SPLASH_SIZE_IPHONE4     CGSizeMake(320, 480)
#define SAX_SPLASH_SIZE_IPHONE5     CGSizeMake(320, 568)
#define SAX_SPLASH_SIZE_IPAD        CGSizeMake(768, 576)
#define SAX_SPLASH_SIZE_NOT_SUPPORT CGSizeMake(0,0)

@protocol SAXSplashViewControllerDelegate;

@interface SAXSplashViewController : UIViewController

@property(nonatomic,weak) id<SAXSplashViewControllerDelegate> delegate;
@property(nonatomic) BOOL testing;
@property(nonatomic) BOOL isUserDefineBrowser;
@property (nonatomic,readonly,strong) SAXSCGIFImageView *imageView;

-(id) initWithAdposId:(NSString *)adposId
//               window:(UIWindow *)window
           background:(UIColor *)bgColor
                 size:(CGSize)size
               offset:(CGFloat)offset;


-(BOOL) isPrepared;

@end

@protocol SAXSplashViewControllerDelegate<NSObject>
//开屏广告展示前调用
//-(void)saxSplashAdWillPresentScreen;
//开屏广告展示后调用
//-(void)saxSplashAdWillDismissScreen;

-(void)saxSplashAdTimeout;

-(void)saxSplashAdWillPresentScreenBackFromBrowser;

//使用自定义浏览器打开
-(void)saxSplashAdBrowerOpenWithUserBrowser:(NSString *)url adViewController:(UIViewController *)controller;
@end
