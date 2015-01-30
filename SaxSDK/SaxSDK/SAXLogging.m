//
//  SAXLogging.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-21.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXLogging.h"

static SAXLogLevel SAXLOG_LEVEL = SAXLogLevelDebug;

SAXLogLevel SAXLogGetLevel()
{
    return SAXLOG_LEVEL;
}

void SAXLogSetLevel(SAXLogLevel level)
{
    SAXLOG_LEVEL = level;
}

void _SAXLogTrace(NSString *format, ...)
{
    if (SAXLOG_LEVEL <= SAXLogLevelTrace)
    {
        format = [NSString stringWithFormat:@"SAX: %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

void _SAXLogDebug(NSString *format, ...)
{
    if (SAXLOG_LEVEL <= SAXLogLevelDebug)
    {
        format = [NSString stringWithFormat:@"SAX: %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

void _SAXLogWarn(NSString *format, ...)
{
    if (SAXLOG_LEVEL <= SAXLogLevelWarn)
    {
        format = [NSString stringWithFormat:@"SAX: %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

void _SAXLogInfo(NSString *format, ...)
{
    if (SAXLOG_LEVEL <= SAXLogLevelInfo)
    {
        format = [NSString stringWithFormat:@"SAX: %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

void _SAXLogError(NSString *format, ...)
{
    if (SAXLOG_LEVEL <= SAXLogLevelError)
    {
        format = [NSString stringWithFormat:@"SAX: %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

void _SAXLogFatal(NSString *format, ...)
{
    if (SAXLOG_LEVEL <= SAXLogLevelFatal)
    {
        format = [NSString stringWithFormat:@"SAX: %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}
