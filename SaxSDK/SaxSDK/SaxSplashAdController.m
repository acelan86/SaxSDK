//
//  SaxSplashController.m
//  SaxSDK
//
//  Created by wuqiang on 14/10/28.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SaxSplashAdController.h"
#import "SaxSplashAdRequestManager.h"
#import "SaxSplashAdUtil.h"
#import "SAXSplashViewController.h"
#import "SAXReachability.h"
#import "SAXLogging.h"
#import "SaxSplashAdCacheUtil.h"
#import "SaxNavigationControllerViewController.h"

@interface SaxSplashAdController() <SAXSplashViewControllerDelegate>
@property (nonatomic,strong) SAXSplashViewController *splashViewController;
@property (nonatomic,strong) UIWindow *adWindow;

@end

@implementation SaxSplashAdController

@synthesize delegate = _delegate;

//检查是否有可以展示的广告
+(BOOL)shouldShowAd:(CGSize)size {
    @try{
        //清理过期缓存
        [SaxSplashAdCacheUtil clearExpireCache];
        
        NSData *image = [SaxSplashAdUtil adImage:size];
        return [[SAXReachability reachabilityForInternetConnection] isReachable] && size.width != SAX_SPLASH_SIZE_NOT_SUPPORT.width && size.height != SAX_SPLASH_SIZE_NOT_SUPPORT.height && image;
    }@catch (NSException * e) {
        SAXLogDebug(@"Exception: %@", e);
        return NO;
    }

}

+(void) requestAd:(NSString *)adposId size:(CGSize)size testing:(BOOL)isTesting{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperationWithBlock:^{
            SaxSplashAdRequestManager *requestManager = [[SaxSplashAdRequestManager alloc] initWithAdunitId:adposId size:size];
            requestManager.testing = isTesting;
            [requestManager requestAd];
        }];
    }@catch (NSException * e) {
        SAXLogDebug(@"Exception: %@", e);

    }
}


+(void) requestAd:(NSString *)adposId size:(CGSize)size {
    [SaxSplashAdController requestAd:adposId size:size testing:NO];
}

-(void) present:(NSString *)adposId
     background:(UIColor *)bgColor
           size:(CGSize)size
         offset:(CGFloat)offset
         browser:(BOOL)isUserDefine{
    @try {
        _adWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _adWindow.windowLevel = UIWindowLevelNormal + 1;
        _splashViewController = [[SAXSplashViewController alloc] initWithAdposId:adposId background:bgColor size:size offset:offset];
        _splashViewController.isUserDefineBrowser = isUserDefine;
        _splashViewController.delegate = self;
        
        UINavigationController *controller = [[SaxNavigationControllerViewController alloc] initWithRootViewController:_splashViewController];
        
        if (controller.navigationBar.hidden == NO) {
            [controller setNavigationBarHidden:YES];
        }
        _adWindow.rootViewController = controller;

        if ([_splashViewController isPrepared]) {
            [_adWindow makeKeyAndVisible];
        }else {
            if ([self.delegate respondsToSelector:@selector(saxSplashAdShowError)]) {
                [self.delegate saxSplashAdShowError];
            }
        }
        
    }
    @catch (NSException *e) {
        SAXLogDebug(@"Exception: %@", e);
    }
}

#pragma mark SAXSplashViewControllerDelegate

//开屏广告展示前调用
//-(void)saxSplashAdWillPresentScreen {
//    if ([self.delegate respondsToSelector:@selector(saxSplashAdWillPresentScreen)]) {
//        [self.delegate saxSplashAdWillPresentScreen];
//    }
//}

//开屏广告展示后调用
//-(void)saxSplashAdWillDismissScreen {
//    if ([self.delegate respondsToSelector:@selector(saxSplashAdWillDismissScreen)]) {
//        [self.delegate saxSplashAdWillDismissScreen];
//    }
//}


-(void)saxSplashAdTimeout {
    //先invalidate掉timer，否则会内存泄露
    if (_splashViewController.imageView.timer != nil && [_splashViewController.imageView.timer isValid]) {
        [_splashViewController.imageView.timer invalidate];
        _splashViewController.imageView.timer = nil;
    }
   
    if ([self.delegate respondsToSelector:@selector(saxSplashAdTimeout)]) {
        [self.delegate saxSplashAdTimeout];
    }
}

-(void)saxSplashAdWillPresentScreenBackFromBrowser {
    if ([self.delegate respondsToSelector:@selector(saxSplashAdWillPresentScreenBackFromBrowser)]) {
        [self.delegate saxSplashAdWillPresentScreenBackFromBrowser];
    }
}

//用户自定义浏览器打开
-(void)saxSplashAdBrowerOpenWithUserBrowser:(NSString *)url adViewController:(UIViewController *)controller{
    if ([self.delegate respondsToSelector:@selector(saxSplashAdBrowerOpenWithUserBrowser:adViewController:)]) {
        [self.delegate saxSplashAdBrowerOpenWithUserBrowser:url adViewController:controller];
    }
}

-(void) dealloc {
    SAXLogDebug(@"SaxSplashAdController dealloc ...");
}



@end
