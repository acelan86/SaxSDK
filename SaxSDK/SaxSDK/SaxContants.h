//
//  SaxContants.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-5.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <UIKit/UIKit.h>
//debug 模式 0：不启用debug，1：启用debug
#define SAX_DEBUG_MODE          0

//#define SAX_SERVER_VERSION      @"1"
#define SAX_SDK_VERSION         @"1.0.3"

//SAX请求地址
#define SAX_HOST_ONLINE   @"sax.sina.com.cn"
//#define SAX_HOST_TESTING  @"10.210.213.46"
#define SAX_HOST_TESTING @"10.210.238.204"


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


