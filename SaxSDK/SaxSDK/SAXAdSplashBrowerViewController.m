//
//  SAXAdBrowerViewController.m
//  SaxSDK
//
//  Created by wuqiang on 14-7-24.
//  Copyright (c) 2014年 Sina. All rights reserved.
//

#import "SAXAdSplashBrowerViewController.h"
#import "SAXLogging.h"
#import "SAXInfoProvider.h"

static const CGFloat kBarHeight = 64.0f; //status bar + navigation bar

@interface SAXAdSplashBrowerViewController ()
@property (nonatomic) NSInteger webViewLoadCount;

@property (nonatomic) BOOL isLoadingDestination;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@end

#define kNumEncodingsToTry 2
static NSStringEncoding gEncodingWaterfall[kNumEncodingsToTry] = {NSUTF8StringEncoding, NSISOLatin1StringEncoding};

@implementation SAXAdSplashBrowerViewController

@synthesize delegate = _delegate;
@synthesize spinner = _spinner;
@synthesize oldRoot = _oldRoot;


-(id)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

-(void) loadView {

    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //记录打开前status bar的状态
//    self.isHidden = [[UIApplication sharedApplication] isStatusBarHidden];
//    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,kBarHeight, self.view.frame.size.width, self.view.frame.size.height)];
//    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];

    self.webView.opaque = NO;
    self.webView.delegate = self;
    
    [self.webView loadRequest:[[SAXInfoProvider shareInstance] buildRequestWithURL:self.url]];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SaxSDKBundle" ofType:@"bundle"]];
    NSString *strPath = [bundle pathForResource:@"SAXBrowerBackBtn" ofType:@"png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageWithContentsOfFile:strPath] forState:UIControlStateNormal];

    [leftButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    

    [self.view addSubview:_webView];

    self.webViewLoadCount = 0;
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_spinner];
}

- (void)cancel
{
    [self.connection cancel];
    self.connection = nil;
    self.isLoadingDestination = NO;
}

//请求页面
-(void) requestUrl{
    [self p_displayDestionForUrl:self.url];
}

#pragma mark - Hidding status bar (iOS 7 and above)

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}


-(void) viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if ([self.delegate respondsToSelector:@selector(browerViewWillAppear)]) {
//        [self.delegate browerViewWillAppear];
//    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![_spinner isAnimating]) {
        [self.spinner startAnimating];
    }
}

-(void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
//    if ([self.delegate respondsToSelector:@selector(browerViewDidDisappear)]) {
//        [self.delegate browerViewDidDisappear];
//    }
    [super viewDidDisappear:animated];
}


-(void) closeButtonClick {
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    SAXLogDebug(@"Ad browser (%p) starting to load URL: %@", self, request.URL);
    if (request.URL != nil && request.URL.host != nil) {
        self.url = request.URL;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    if (![self.spinner isAnimating]) {
        [self.spinner startAnimating];
    }
    self.webViewLoadCount++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webViewLoadCount--;
    if (self.webViewLoadCount > 0) return;
    
    if ([self.spinner isAnimating]) {
        [self.spinner stopAnimating];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webViewLoadCount--;
    
    [self.spinner stopAnimating];
    
    // Ignore NSURLErrorDomain error (-999).
    if (error.code == NSURLErrorCancelled) return;
    
    // Ignore "Frame Load Interrupted" errors after navigating to iTunes or the App Store.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    
    SAXLogDebug(@"Ad browser (%p) experienced an error: %@.", self, [error localizedDescription]);
}


#pragma mark NSURLConnectionDelegate
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if([response respondsToSelector:@selector(statusCode)]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if(statusCode >= 400) {
            [connection cancel];
            self.isLoadingDestination = NO;
            // [self.delegate communicatorDidFailWithError:nil];
            return;
        }
    }
    self.responseData = [NSMutableData data];
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.isLoadingDestination = NO;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self p_showWebViewWithHTMLString:[self p_htmlStringForData:self.responseData] baseURL:self.url];
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


#pragma mark private

//请求跳转URL
-(void) p_displayDestionForUrl:(NSURL *)url {
    if (_isLoadingDestination) {
        return;
    }
    _isLoadingDestination = YES;
    
    [self.connection cancel];
    self.url = url;
    
    
    NSURLRequest *request = [[SAXInfoProvider shareInstance] buildRequestWithURL:self.url];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//把NSData转化为html
- (NSString *)p_htmlStringForData:(NSData *)data
{
    NSString *htmlString = nil;
    
    for(int i = 0; i < kNumEncodingsToTry; i++)
    {
        htmlString = [[NSString alloc] initWithData:data encoding:gEncodingWaterfall[i]];
        if(htmlString != nil)
        {
            break;
        }
    }
    return htmlString;
}

- (void)p_showWebViewWithHTMLString:(NSString *)html baseURL:(NSURL *)url {
    [self.webView loadHTMLString:html baseURL:url];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    [self.webView loadHTMLString:nil baseURL:nil];
    [self.webView removeFromSuperview];
    self.webView.delegate = nil;
    SAXLogDebug(@"SAXAdSplashBrowerViewController dealloc.");
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
