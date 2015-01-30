//
//  SAXSplashViewController.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-17.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXSplashViewController.h"
#import "SAXAdServerCommunicator.h"
#import "SAXSplashAdShowManager.h"
#import "SAXLogging.h"
#import "SaxContants.h"
#import "SAXTimer.h"
#import "SAXSCGIFImageView.h"
#import "SAXReachability.h"
#import "SAXAdSplashBrowerViewController.h"
#import "SAXNSStringUtil.h"
#import "SaxSplashAdRequestManager.h"
#import "SaxSplashAdCacheUtil.h"
#import "SaxSplashAdUtil.h"
#import "SaxNavigationControllerViewController.h"


static const CGFloat kAdLastSeconds = 3.0f;

@interface SAXSplashViewController ()
@property (nonatomic,weak) UIWindow *uiWindow;
@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,strong) NSString *adposId;
@property (nonatomic,strong) SAXSplashAdShowManager *showManager;
@property (nonatomic) CGFloat offset;
@property (nonatomic) CGSize size;
@property (nonatomic,strong) SAXTimer *timeoutTimer;
@property (atomic) BOOL isClicked;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) int appearCounter;
@end

@implementation SAXSplashViewController

@synthesize uiWindow = _uiWindow;
@synthesize delegate = _delegate;
@synthesize backgroundColor = _backgroundColor;
@synthesize adposId = _adposId;
@synthesize testing = _testing;
@synthesize isUserDefineBrowser = _isUserDefineBrowser;
@synthesize imageView = _imageView;


-(id)initWithAdposId:(NSString *)adposId
//              window:(UIWindow *)window
          background:(UIColor *)bgColor size:(CGSize)size offset:(CGFloat)offset {
    self = [super init];
    if (self) {
        _adposId = adposId;
        _backgroundColor = bgColor;
        _offset = offset;
        _size = size;
//        _uiWindow = window;
        _isUserDefineBrowser = NO;
        _showManager = [[SAXSplashAdShowManager alloc] initWithAdunitId:adposId
                                                           size:size];
        _appearCounter = 0;
    }
    return self;
}

-(BOOL) isPrepared {
    @try {        
        if ([[SAXReachability reachabilityForInternetConnection] isReachable] && _size.width != SAX_SPLASH_SIZE_NOT_SUPPORT.width && _size.height != SAX_SPLASH_SIZE_NOT_SUPPORT.height && [_showManager prepare]) {
            return YES;
        }
    }@catch (NSException * e) {
        SAXLogDebug(@"Exception: %@", e);
    }
    return NO;
}

-(void) loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = self.backgroundColor;
    
    _imageView = [[SAXSCGIFImageView alloc] initWithFrame:CGRectMake(0, self.offset, self.size.width, self.size.height)];
    [_imageView setData:_showManager.image];
    [self.view addSubview:_imageView];
    
}


-(void) viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleTap)];
    [_imageView addGestureRecognizer:tapRecognizer];
    _imageView.userInteractionEnabled = YES; //使ImageView响应事件
    
    //用定时器计时，直接sleep会阻塞主进程,从而使gesture
    [self p_startTimeoutTimer];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _appearCounter++;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setFrame:[UIScreen mainScreen].bounds];
    
    /**
     * 如果浏览器
     */
    
    //执行回调
    if (_appearCounter != 1) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if ([self.delegate respondsToSelector:@selector(saxSplashAdWillPresentScreenBackFromBrowser)]) {
            [self.delegate saxSplashAdWillPresentScreenBackFromBrowser];
        }
    }else {
        //展现时发送曝光请求
        SAXLogDebug(@"Send track impression request ... ");
        [_showManager trackImpression];
    }

}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}


-(void) viewDidDisappear:(BOOL)animated {
    [_showManager trackClose];
    _isClicked = NO;
    [super viewDidDisappear:animated];
}

//屏幕旋转
//IOS6
- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

//IOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private

-(void) p_startTimeoutTimer {
    NSTimeInterval timeInterval =  kAdLastSeconds;
    
    if (timeInterval > 0) {
        self.timeoutTimer = [SAXTimer timerWithTimeInterval:timeInterval target:self selector:@selector(p_timeout) repeats:NO];
        
        [self.timeoutTimer scheduleNow];
    }
}

-(void)p_handleTap{
    SAXLogDebug(@"Splash Ad is clicked. ");
    
    //先invalidate掉timer，否则会内存泄露
    if (_imageView.timer != nil && [_imageView.timer isValid]) {
        [_imageView.timer invalidate];
        _imageView.timer = nil;
    }
   
    
    //已点击过直接返回
    if (_isClicked) {
        return;
    }
    
    //为空时直接返回
    if (![SAXAdResponse validateCommon:_showManager.responseContent.link]) {
        return;
    }
    
    _isClicked = YES;
 
    NSString *link = [_showManager.responseContent.link objectAtIndex:0];
    
    //空字符串直接返回
    if(![SAXNSStringUtil notEmpty:link]) {
        return;
    }
    
    //发送点击监控
    [_showManager trackClick];
    
    NSString *tmpLink = [link lowercaseString];
    
    if([tmpLink hasPrefix:@"http"] || [tmpLink hasPrefix:@"https"]) {
        if ([tmpLink hasPrefix:@"http://itunes.apple.com"] || [tmpLink hasPrefix:@"https://itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }else {
            [self p_openWithBrower:link];
        }
    }
}

-(void)p_timeout {
    [self.timeoutTimer invalidate];
    if ([self.delegate respondsToSelector:@selector(saxSplashAdTimeout)]) {
        [self.delegate saxSplashAdTimeout];
    }
}

-(void)p_openWithBrower:(NSString *)link{
    [self.timeoutTimer invalidate];
    if (_isUserDefineBrowser) {
        SAXLogDebug(@"user define brower");
        if ([self.delegate respondsToSelector:@selector(saxSplashAdBrowerOpenWithUserBrowser:adViewController:)]) {
            [self.delegate saxSplashAdBrowerOpenWithUserBrowser:link adViewController:self];
        }
    }else {
        SAXAdSplashBrowerViewController *browerController = [[SAXAdSplashBrowerViewController alloc] initWithUrl:[NSURL URLWithString:link]];
        
        if (self.navigationController.navigationBar.hidden == YES) {
            [self.navigationController setNavigationBarHidden:NO];
        }
       
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }else {
            [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        }
        
        [self.navigationController pushViewController:browerController animated:NO];

    }
}



//IOS7 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}



-(void) dealloc {
    SAXLogDebug(@"SAXSplashViewController dealloc");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
