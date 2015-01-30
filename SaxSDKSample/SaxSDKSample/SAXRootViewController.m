//
//  SAXRootViewController.m
//  SaxSDKSample
//
//  Created by wuqiang on 14-8-24.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SAXRootViewController.h"

@interface SAXRootViewController ()
@property(nonatomic,strong) UILabel *topLabel;
@property(nonatomic,strong) UIButton *setStatusBarButton;

@end

@implementation SAXRootViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//    
//}

-(void) loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.topLabel.backgroundColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.topLabel];
    
    self.setStatusBarButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    [self.setStatusBarButton setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:self.setStatusBarButton];
    
    [self.setStatusBarButton addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
}



-(void) clickbutton {
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString *className = [NSString stringWithUTF8String:object_getClassName([UIApplication sharedApplication].keyWindow.rootViewController)];
//    NSLog(@"className:%@",className);
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
//    NSString *className = [NSString stringWithUTF8String:object_getClassName([UIApplication sharedApplication].keyWindow.rootViewController)];
//    NSLog(@"className:%@",className);
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//IOS6
- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

@end
