//
//  SAXAdBrowerViewController.h
//  SaxSDK
//
//  Created by wuqiang on 14-7-24.
//  Copyright (c) 2014年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAXAdBrowerViewControllerDelegate;

@interface SAXAdBrowerViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) UIBarButtonItem *forwardButton;
@property (nonatomic,strong) UIBarButtonItem *refreshButton;
@property (nonatomic,strong) UIBarButtonItem *safariButton;
@property (nonatomic,strong) UIBarButtonItem *closeButton;
@property (nonatomic,strong) UIBarButtonItem *spinnerItem;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,assign) id<SAXAdBrowerViewControllerDelegate> delegate;


-(id)initWithUrl:(NSURL *)url;
-(void) requestUrl;
@end

@protocol SAXAdBrowerViewControllerDelegate <NSObject>
-(void) closeButtonClicked;
-(void) browerViewWillAppear;
-(void) browerViewWillDisappear;
-(void) browerViewDidDisappear;

@end


