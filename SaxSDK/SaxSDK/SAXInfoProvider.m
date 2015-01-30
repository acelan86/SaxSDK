//
//  SAXInfoProvider.m
//  Saxmob
//
//  Created by wuqiang on 14-5-19.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXInfoProvider.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "SAXLogging.h"
#import "SAXNSStringUtil.h"
#import "SAXReachability.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#import <AdSupport/AdSupport.h>
#endif

//static NSString *const kInternetConnectionHostName = @"www.baidu.com";


@interface SAXInfoProvider()
@property (nonatomic, strong, readonly) NSString *deviceType;
@property (nonatomic, strong, readonly) NSString *osVersion;
@property (nonatomic, strong, readonly) SAXIdentity *identity;
@property (nonatomic, strong, readonly) NSString *macAddress;
@property (nonatomic, strong, readonly) NSString *resolution;
@property (nonatomic, strong, readonly) NSDictionary *infoDict;
@property (nonatomic, strong, readonly) NSString *userAgent;

@end


@implementation SAXInfoProvider

@synthesize deviceType = _deviceType;
@synthesize osVersion = _osVersion;
@synthesize macAddress = _macAddress;
@synthesize identity = _identity;
@synthesize resolution = _resolution;
@synthesize infoDict = _infoDict;
@synthesize userAgent = _userAgent;


+(SAXInfoProvider *) shareInstance {
    static SAXInfoProvider *saxInfoProvider = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        SAXLogDebug(@"Get the singlton SAXInfoProvider.");
        saxInfoProvider = [[SAXInfoProvider alloc] init];
    });
    return saxInfoProvider;
}

#pragma mark public
-(NSString *) deviceType {
    if(_deviceType == nil) {
        SAXLogDebug(@"Get devide type for the first time.");
        _deviceType = [self p_deviceTypeString];
    }
    return _deviceType;
}

-(NSString *) osVersion {
    if(_osVersion == nil) {
        SAXLogDebug(@"Get the os version for the first time.");
        NSString *ios = @"IOS";
        _osVersion = [ios stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
    }
    return _osVersion;
}

-(NSString *)macAddress {
    
    if (_macAddress == nil) {
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1\n");
            return NULL;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            free(buf);
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
        
        _macAddress =  outstring;
    }
    return _macAddress;

}

-(NSString *)md5MacAddress {
    return [SAXNSStringUtil stringToMd5:[self macAddress]];
}

-(SAXIdentity *) identifier {
    if(_identity == nil) {
        if ([self p_deviceHasASIdentifierManager]) {
            _identity = [[SAXIdentity alloc] initWithType:@"IDFA" andValue:[self p_identifierFromASIdentifierManager]];
        }
        if(_identity == nil) {
             _identity = [[SAXIdentity alloc] initWithType:@"MAC" andValue:[self md5MacAddress]];
        }
    }
    return _identity;
}

-(CGSize) screenSize {
    return [[UIScreen mainScreen] bounds].size;
}

-(NSString *)resolution {
    if (_resolution == nil) {
        CGSize size = [self screenSize];
        NSDecimalNumber *width = [[NSDecimalNumber alloc] initWithFloat:size.width];
        NSDecimalNumber *height = [[NSDecimalNumber alloc] initWithFloat:size.height];
        _resolution =  [NSString stringWithFormat:@"%d*%d", [width intValue], [height intValue]];
    }
    return _resolution;
}

-(UIInterfaceOrientation) orientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

-(NSString *) bundleIdentifier {
    return [[NSString alloc] initWithFormat:@"%@",[[self p_infoDictionary] objectForKey:@"CFBundleIdentifier"]];
}

//-(BOOL) isConnectionRequired {
////    Reachability *reachability = [Reachability reachabilityWithHostName:INTERNET_CONNECTION_HOST_NAME];
////    SAXLogDebug(@"isConnectionRequired network type: %d, hostname:%@",[reachability isConnectionRequired],INTERNET_CONNECTION_HOST_NAME);
////    return [reachability connectionRequired];
//    
//    NSURL *url = [NSURL URLWithString:INTERNET_CONNECTION_HOST_NAME];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
//    NSHTTPURLResponse *response;
//    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
////NSLog(@"Testing connection required. url:%@", INTERNET_CONNECTION_HOST_NAME);
//[NSThread sleepForTimeInterval:10.0];
//    if (response == nil) {
//        return NO;
//    }
//    else{
//        return YES;
//    }
//}

-(NSInteger)networkType {
    NSInteger ret = 0; //unknown
    switch ([self p_networkType]) {
        case NotReachable:
            ret = -1;
            break;
        case ReachableViaWiFi:
            ret = 1;
            break;
        case ReachableViaWWAN:
            ret = 3;
            break;
        default:
            ret = 0;
            break;
    }
    return ret;
}

-(BOOL) isWIFI {
    if ([self p_networkType] == ReachableViaWiFi) {
        return YES;
    }else {
        return NO;
    }
}

-(NSString *)appVersion {
    return [[self p_infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(NSString *)carrierName {
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    return [carrier carrierName];
}


#pragma mark private

- (NSString *) p_deviceTypeString{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        platform = @"iPhone";
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        platform = @"iPhone 3G";
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        platform = @"iPhone 3GS";
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        platform = @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        platform = @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        platform = @"iPhone 5";
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        platform = @"iPhone 5C";
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        platform = @"iPhone 5S";
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        platform = @"iPod touch 4";
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        platform = @"iPod touch 5";
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        platform = @"iPod touch 3";
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        platform = @"iPod touch 2";
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        platform = @"iPod touch";
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        platform = @"iPad 3";
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        platform = @"iPad 2";
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        platform = @"iPad 1";
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        platform = @"ipad mini";
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        platform = @"ipad 3";
    }
    
    return platform;
}

- (BOOL)p_advertisingTrackingEnabled
{
    BOOL enabled = YES;
    
    if ([self p_deviceHasASIdentifierManager]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
#endif
    }
    
    return enabled;
}

- (BOOL)p_deviceHasASIdentifierManager
{
    return !!NSClassFromString(@"ASIdentifierManager");
}

- (NSString *)p_identifierFromASIdentifierManager
{
    NSString *identifier = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    identifier = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
#endif
    return identifier;
}

-(NSDictionary *) p_infoDictionary {
    if (_infoDict == nil) {
        _infoDict = [[NSBundle mainBundle] infoDictionary];
//        SAXLogDebug(@"Info dictionary: %@", _infoDict);
    }
    return _infoDict;
}


-(NetworkStatus)p_networkType:(NSString *)hostname {
    SAXReachability *reachability = [SAXReachability reachabilityWithHostName:hostname];
    return [reachability currentReachabilityStatus];
}

-(NetworkStatus)p_networkType {
    SAXReachability *reachability = [SAXReachability reachabilityForInternetConnection];
    return [reachability currentReachabilityStatus];
}

- (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    return request;
}

- (NSString *)userAgent
{
    if (!_userAgent) {
        _userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    
    return _userAgent;
}

@end

@implementation SAXIdentity
@synthesize type = _type;
@synthesize value = _value;

-(SAXIdentity *)initWithType:(NSString *)type andValue:(NSString *)value {
    self = [super init];
    if (self) {
        _type = type;
        _value = value;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"type=%@, value=%@",_type,_value ];
}
@end
