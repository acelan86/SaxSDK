//
//  SAXLogging.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-21.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaxContants.h"

// Lower = finer-grained logs.
typedef enum
{
    SAXLogLevelAll        = 0,
    SAXLogLevelTrace        = 10,
    SAXLogLevelDebug        = 20,
    SAXLogLevelInfo        = 30,
    SAXLogLevelWarn        = 40,
    SAXLogLevelError        = 50,
    SAXLogLevelFatal        = 60,
    SAXLogLevelOff        = 70
} SAXLogLevel;

SAXLogLevel SAXLogGetLevel(void);
void SAXLogSetLevel(SAXLogLevel level);
void _SAXLogTrace(NSString *format, ...);
void _SAXLogDebug(NSString *format, ...);
void _SAXLogInfo(NSString *format, ...);
void _SAXLogWarn(NSString *format, ...);
void _SAXLogError(NSString *format, ...);
void _SAXLogFatal(NSString *format, ...);

#if SAX_DEBUG_MODE && !SPECS

#define SAXLogTrace(...) _SAXLogTrace(__VA_ARGS__)
#define SAXLogDebug(...) _SAXLogDebug(__VA_ARGS__)
#define SAXLogInfo(...) _SAXLogInfo(__VA_ARGS__)
#define SAXLogWarn(...) _SAXLogWarn(__VA_ARGS__)
#define SAXLogError(...) _SAXLogError(__VA_ARGS__)
#define SAXLogFatal(...) _SAXLogFatal(__VA_ARGS__)

#else

#define SAXLogTrace(...) {}
#define SAXLogDebug(...) {}
#define SAXLogInfo(...) {}
#define SAXLogWarn(...) {}
#define SAXLogError(...) {}
#define SAXLogFatal(...) {}

#endif
