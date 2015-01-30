//
//  SAXAdServerCommunicator.m
//  SaxSDK
//
//  Created by wuqiang on 14-5-5.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import "SAXAdServerCommunicator.h"
#import "SAXAdRequest.h"
#import "SAXAdParameterBuilder.h"
#import "SAXLogging.h"
#import "SAXAdResponse.h"
#import "SAXDateUtil.h"
#import "SaxContants.h"

static const NSTimeInterval kRequestTimeoutInterval = 10.0;


@interface SAXAdServerCommunicator()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSDictionary *responseHeaders;

@end

@implementation SAXAdServerCommunicator

@synthesize delegate = _delegate;
@synthesize connection = _connection;


#pragma mark - public

-(id) initWithDelegate:(id<SAXAdServerCommunicatorDelegate>)delegate {
    self = [super init];
    if(self) {
        self.delegate = delegate;
    }
    return self;
}

-(void) loadAdwithAdunitId:(NSString *)adunitId size:(NSString *)size testing:(BOOL)testing{
    [self loadAdwithAdunitId:adunitId size:size rotate:arc4random() / 1000000 andTimeStramp: [NSString stringWithFormat:@"%lld", [SAXDateUtil now]] testing:testing];
}

-(void) loadAdwithAdunitId:(NSString *)adunitId size:(NSString *)size rotate:(NSInteger)rotate andTimeStramp:(NSString *)timestamp testing:(BOOL)testing{
    [self cancel];
    NSString *dataStr = [[SAXAdParameterBuilder alloc] urlWithAdunitId:adunitId size:size rotate:rotate andTimestamp:timestamp];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://%@/mobile/impress",testing ? SAX_HOST_TESTING : SAX_HOST_ONLINE];
    self.connection = [NSURLConnection connectionWithRequest:[self p_adRequestForURL:[NSURL URLWithString:url] andData:data] delegate:self];
    self.loading = YES;
}

#pragma mark - delegate

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if([response respondsToSelector:@selector(statusCode)]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if(statusCode >= 400) {
            [connection cancel];
            self.loading = NO;
            [self.delegate communicatorDidFailWithError:nil];
            return;
        }
    }
    self.responseData = [NSMutableData data];
    self.responseHeaders = [(NSHTTPURLResponse *)response allHeaderFields];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.loading = NO;
    [self.delegate communicatorDidFailWithError:error];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    self.loading = NO;
    
    SAXLogDebug(@"response Data:%@", [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:nil] );
    [self.delegate communicatorDidReceiverJsonResult:self.responseData];
}

-(void) cancel {
    [self.connection cancel];
    self.connection = nil;
    self.loading = NO;
}

#pragma mark - private

- (NSURLRequest *)p_adRequestForURL:(NSURL *)URL andData:(NSData *)data {
    SAXAdRequest *request = [[SAXAdRequest alloc] initPostRequestWithUrl:URL andData:data timeoutInterval:kRequestTimeoutInterval];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    return request;
}



@end
