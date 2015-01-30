//
//  SAXAdBrowerViewController.m
//  SaxSDK
//
//  Created by wuqiang on 14-7-24.
//  Copyright (c) 2014年 Sina. All rights reserved.
//

#import "SAXAdBrowerViewController.h"

static const CGFloat kToolBarHeight = 44.0f;

@interface SAXAdBrowerViewController ()
@property (nonatomic) NSInteger webViewLoadCount;

@property (nonatomic) BOOL isLoadingDestination;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@end

#define kNumEncodingsToTry 2
static NSStringEncoding gEncodingWaterfall[kNumEncodingsToTry] = {NSUTF8StringEncoding, NSISOLatin1StringEncoding};

@implementation SAXAdBrowerViewController

@synthesize delegate = _delegate;
@synthesize spinner = _spinner;



-(id)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

-(void) loadView {
    
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
          self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kToolBarHeight)];
    }else {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kToolBarHeight - 20.0f)];
    }
  
    
    //    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.opaque = NO;
    self.webView.delegate = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [request setHTTPShouldHandleCookies:YES];
    
    [self.webView loadRequest:request];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kToolBarHeight, self.view.frame.size.width, kToolBarHeight)];

    }else {
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kToolBarHeight - 20.0f, self.view.frame.size.width, kToolBarHeight)];
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIImage *backButtonImage = [self backButtonImage];
    self.backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    
    UIImage *forwardButtonImage = [self forwardButtonImage];
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:forwardButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonClick)
                          ];
    
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClick)];
    
    self.safariButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(safariButtonClick)];
    
    self.closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClick)];
    
    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.spinner sizeToFit];
    //    self.spinner.hidesWhenStopped = YES;
    self.spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    
    [items addObjectsFromArray:[NSArray arrayWithObjects:_spinnerItem,flexSpace, _backButton,flexSpace,_forwardButton,flexSpace,_refreshButton ,flexSpace,_safariButton, flexSpace, _closeButton, nil]];
    [self.toolBar setItems:items];
    
    [self.view addSubview:_webView];
    [self.view addSubview:_toolBar];
    
    self.webViewLoadCount = 0;
    
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

//#pragma mark - Hidding status bar (iOS 7 and above)
//
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
    
    
    if ([self.delegate respondsToSelector:@selector(browerViewWillAppear)]) {
        [self.delegate browerViewWillAppear];
    }
    
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.spinner startAnimating];
    
}

-(void) viewWillDisappear:(BOOL)animated {

    if ([self.delegate respondsToSelector:@selector(browerViewWillDisappear)]) {
        [self.delegate browerViewWillDisappear];
    }
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    
    if ([self.delegate respondsToSelector:@selector(browerViewDidDisappear)]) {
        [self.delegate browerViewDidDisappear];
    }
    [super viewDidDisappear:animated];
}


-(void) backButtonClick {
    [self dismissActionSheet];
    [self.webView goBack];
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

-(void) forwardButtonClick {
    [self dismissActionSheet];
    [self.webView goForward];
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

-(void) refreshButtonClick {
    NSLog(@"refreshButtonClick");
    [self dismissActionSheet];
    [self.webView reload];
}

-(void) safariButtonClick {
    NSLog(@"safariButtonClick");
    if (self.actionSheet) {
        [self dismissActionSheet];
    }else {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Open in Safari", nil];
        if ([UIActionSheet instancesRespondToSelector:@selector(showFromBarButtonItem:animated:)]) {
            [self.actionSheet showFromBarButtonItem:self.safariButton animated:YES];
        } else {
            [self.actionSheet showInView:self.webView];
        }
        
    }
}

- (void)dismissActionSheet
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
    
}

-(void) closeButtonClick {
    if ([self.delegate respondsToSelector:@selector(closeButtonClicked)]) {
        [self.delegate closeButtonClicked];
    }
}


- (UIImage *)backButtonImage {
    UIImage *backButtonImage = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){12,21}, NO, [[UIScreen mainScreen] scale]);
    {
        //// Color Declarations
        UIColor* backColor = [UIColor blackColor];
        
        //// BackButton Drawing
        UIBezierPath* backButtonPath = [UIBezierPath bezierPath];
        [backButtonPath moveToPoint: CGPointMake(10.9, 0)];
        [backButtonPath addLineToPoint: CGPointMake(12, 1.1)];
        [backButtonPath addLineToPoint: CGPointMake(1.1, 11.75)];
        [backButtonPath addLineToPoint: CGPointMake(0, 10.7)];
        [backButtonPath addLineToPoint: CGPointMake(10.9, 0)];
        [backButtonPath closePath];
        [backButtonPath moveToPoint: CGPointMake(11.98, 19.9)];
        [backButtonPath addLineToPoint: CGPointMake(10.88, 21)];
        [backButtonPath addLineToPoint: CGPointMake(0.54, 11.21)];
        [backButtonPath addLineToPoint: CGPointMake(1.64, 10.11)];
        [backButtonPath addLineToPoint: CGPointMake(11.98, 19.9)];
        [backButtonPath closePath];
        [backColor setFill];
        [backButtonPath fill];
        
        backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return backButtonImage;
}

- (UIImage *)forwardButtonImage {
    UIImage *forwardButtonImage = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){12,21}, NO, [[UIScreen mainScreen] scale]);
    {
        //// Color Declarations
        UIColor* forwardColor = [UIColor blackColor];
        
        //// BackButton Drawing
        UIBezierPath* forwardButtonPath = [UIBezierPath bezierPath];
        [forwardButtonPath moveToPoint: CGPointMake(1.1, 0)];
        [forwardButtonPath addLineToPoint: CGPointMake(0, 1.1)];
        [forwardButtonPath addLineToPoint: CGPointMake(10.9, 11.75)];
        [forwardButtonPath addLineToPoint: CGPointMake(12, 10.7)];
        [forwardButtonPath addLineToPoint: CGPointMake(1.1, 0)];
        [forwardButtonPath closePath];
        [forwardButtonPath moveToPoint: CGPointMake(0.02, 19.9)];
        [forwardButtonPath addLineToPoint: CGPointMake(1.12, 21)];
        [forwardButtonPath addLineToPoint: CGPointMake(11.46, 11.21)];
        [forwardButtonPath addLineToPoint: CGPointMake(10.36, 10.11)];
        [forwardButtonPath addLineToPoint: CGPointMake(0.02, 19.9)];
        [forwardButtonPath closePath];
        [forwardColor setFill];
        [forwardButtonPath fill];
        
        forwardButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    
    return forwardButtonImage;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.actionSheet = nil;
    if (buttonIndex == 0)
    {
        // Open in Safari.
        [[UIApplication sharedApplication] openURL:self.url];
    }
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{

    if (request.URL != nil && request.URL.host != nil) {
        self.url = request.URL;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.refreshButton.enabled = YES;
    self.safariButton.enabled = YES;
    if (![self.spinner isAnimating]) {
        [self.spinner startAnimating];
    }
    self.webViewLoadCount++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webViewLoadCount--;
    if (self.webViewLoadCount > 0) return;
    
    self.refreshButton.enabled = YES;
    self.safariButton.enabled = YES;
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    if ([self.spinner isAnimating]) {
        [self.spinner stopAnimating];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webViewLoadCount--;
    
    self.refreshButton.enabled = YES;
    self.safariButton.enabled = YES;
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    [self.spinner stopAnimating];
    
    // Ignore NSURLErrorDomain error (-999).
    if (error.code == NSURLErrorCancelled) return;
    
    // Ignore "Frame Load Interrupted" errors after navigating to iTunes or the App Store.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    

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

//IOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}

//-(void)dealloc {
//    SAXLogDebug(@"SAXAdBrowerViewController dealloc.");
//}

#pragma mark private

//请求跳转URL
-(void) p_displayDestionForUrl:(NSURL *)url {
    if (_isLoadingDestination) {
        return;
    }
    _isLoadingDestination = YES;
    
    [self.connection cancel];
    self.url = url;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [request setHTTPShouldHandleCookies:YES];
//    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
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
