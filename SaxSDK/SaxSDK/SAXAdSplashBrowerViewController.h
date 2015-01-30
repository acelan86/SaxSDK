//
//  SAXAdBrowerViewController.h
//  SaxSDK
//
//  Created by wuqiang on 14-7-24.
//  Copyright (c) 2014年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAXAdSplashBrowerViewControllerDelegate;

@interface SAXAdSplashBrowerViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIBarButtonItem *closeButton;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,weak) id<SAXAdSplashBrowerViewControllerDelegate> delegate;

@property (nonatomic,weak) UIViewController *oldRoot;

-(id)initWithUrl:(NSURL *)url;
-(void) requestUrl;
@end

@protocol SAXAdSplashBrowerViewControllerDelegate <NSObject>
-(void) clickClose;
//-(void) browerViewWillAppear;
//-(void) browerViewWillDisappear;
//-(void) browerViewDidDisappear;
@end


