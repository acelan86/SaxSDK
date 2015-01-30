//
//  SAXAppDelegate.m
//  SaxSDKSample
//
//  Created by wuqiang on 14-8-21.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SAXAppDelegate.h"
#import "SAXRootViewController.h"
#import "SAXMediaViewController.h"
#import "SaxSplashAdController.h"
#import "SAXAdBrowerViewController.h"


@interface SAXAppDelegate() <SaxSplashAdControllerDelegate, SAXAdBrowerViewControllerDelegate>
@property (nonatomic,strong) SaxSplashAdController *splashController;
@end

@implementation SAXAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootViewController = [[SAXRootViewController alloc] init];
    self.window.rootViewController = rootViewController;

    // 1. 设置适合的背景图片
    NSString *defaultImgName = @"LaunchImage-700";
    CGFloat offset = 0.0f;
    CGSize adSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        adSize = SAX_SPLASH_SIZE_IPAD;
        defaultImgName = @"LaunchImage-700-568h";
        
    } else {
        if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
            defaultImgName = @"LaunchImage-700-568h";
            adSize = SAX_SPLASH_SIZE_IPHONE5;
            offset = 0.0f;
        } else if ([UIScreen mainScreen].bounds.size.height == 480.0f){
            adSize = SAX_SPLASH_SIZE_IPHONE4;
            offset = 0.0f;
        } else {
            adSize = SAX_SPLASH_SIZE_NOT_SUPPORT;
            offset = 0.0f;
        }
    }
    
    //2. 定义广告位
//    NSString *adposid = @"PDPS000000055126"; //新闻
//    NSString *adposid = @"PDPS000000054648"; //体育
//    NSString *adposid = @"PDPS000000055385"; //财经
    
    NSString *adposid = @"iphsplashscr";
    
    //3. 新建广告controller并设置回调
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:defaultImgName]];
    
    if ([SaxSplashAdController shouldShowAd:adSize]) {
         _splashController = [[SaxSplashAdController alloc] init];
        //参数brower=NO，表示不使用用户自定义浏览器，而使用sdk提供的
        [_splashController present:adposid  background:bgColor size:adSize offset:offset browser:NO];
        [SaxSplashAdController requestAd:adposid size:adSize];
        _splashController.delegate = self;

    }else {
        [SaxSplashAdController requestAd:adposid size:adSize];
        _splashController = nil;
        [self.window makeKeyAndVisible];
    };

    return YES;
}




//开屏广告展示后调用，销毁广告
-(void)saxSplashAdTimeout {
    NSLog(@"callback saxSplashAdTimeout.");
    [_splashController release];
    _splashController = nil;
    if(self.window == nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIViewController *rootViewController = [[SAXRootViewController alloc] init];
        self.window.rootViewController = rootViewController;

    }
    [self.window makeKeyAndVisible];
}

//从sdk的浏览器返回后调用，销毁广告
-(void)saxSplashAdWillPresentScreenBackFromBrowser {
    NSLog(@"callback saxSplashAdWillPresentScreenBackFromBrowser.");
    [self.window makeKeyAndVisible];
    [_splashController release];
    _splashController = nil;
}

//展示出现错误时调用，销毁广告
-(void)saxSplashAdShowError {
     NSLog(@"callback saxSplashAdShowError.");
    [_splashController release];
    _splashController = nil;
    [self.window makeKeyAndVisible];
}

//使用自定义浏览器打开
-(void)saxSplashAdBrowerOpenWithUserBrowser:(NSString *)url adViewController:(UIViewController *)controller{
    NSLog(@"callback saxSplashAdBrowerOpenWithUserBrowser");
    NSLog(@"x:%f",controller.navigationController.view.bounds.origin.x);
    
    SAXAdBrowerViewController *browerController = [[SAXAdBrowerViewController alloc] initWithUrl:[NSURL URLWithString:url]];
    browerController.delegate = self;
    [controller.navigationController pushViewController:browerController animated:NO];
}

#pragma mark SAXAdBrowerViewControllerDelegate
//用户自定义浏览器点击关闭按钮的回调，为了屏幕不闪动，需要回退时直接销毁
-(void)closeButtonClicked {
    [self.window makeKeyAndVisible];
    [_splashController release];
    _splashController = nil;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // 1. 设置适合的背景图片
    NSString *defaultImgName = @"LaunchImage-700";
    CGFloat offset = 0.0f;
    CGSize adSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        adSize = SAX_SPLASH_SIZE_IPAD;
        defaultImgName = @"LaunchImage-700-568h";
        
    } else {
        if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
            defaultImgName = @"LaunchImage-700-568h";
            adSize = SAX_SPLASH_SIZE_IPHONE5;
            offset = 0.0f;
        } else if ([UIScreen mainScreen].bounds.size.height == 480.0f){
            adSize = SAX_SPLASH_SIZE_IPHONE4;
            offset = 0.0f;
        } else {
            adSize = SAX_SPLASH_SIZE_NOT_SUPPORT;
            offset = 0.0f;
        }
    }
    
    //2. 定义广告位
    //    NSString *adposid = @"PDPS000000055126"; //新闻
    //    NSString *adposid = @"PDPS000000054648"; //体育
    //    NSString *adposid = @"PDPS000000055385"; //财经
    
    NSString *adposid = @"iphsplashscr";
    
    //3. 新建广告controller并设置回调
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:defaultImgName]];
    
    if ([SaxSplashAdController shouldShowAd:adSize]) {
        _splashController = [[SaxSplashAdController alloc] init];
        //参数brower=NO，表示不使用用户自定义浏览器，而使用sdk提供的
        [_splashController present:adposid  background:bgColor size:adSize offset:offset browser:YES];
        [SaxSplashAdController requestAd:adposid size:adSize];
        _splashController.delegate = self;
        
    }else {
        [SaxSplashAdController requestAd:adposid size:adSize];
        _splashController = nil;
        [self.window makeKeyAndVisible];
    };

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
