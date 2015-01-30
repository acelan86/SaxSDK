//
//  SAXAdServerCommunicator.h
//  SaxSDK
//
//  Created by wuqiang on 14-5-5.
//  Copyright (c) 2014年 ad. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SAXAdServerCommunicatorDelegate;

@interface SAXAdServerCommunicator : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<SAXAdServerCommunicatorDelegate> delegate;
@property (nonatomic) BOOL loading;


-(id) initWithDelegate:(id<SAXAdServerCommunicatorDelegate>) delegate;

//-(void) loadAdwithAdunitId:(NSString *)adunitId
//                      size:(NSString *)size
//                    rotate:(NSInteger)rotate
//             andTimeStramp:(NSString *)timestamp
//                   testing:(BOOL)testing;

-(void) loadAdwithAdunitId:(NSString *)adunitId size:(NSString *)size testing:(BOOL)testing;

-(void) cancel;

@end

@protocol SAXAdServerCommunicatorDelegate <NSObject>

-(void) communicatorDidReceiverJsonResult:(NSData *)data;
-(void) communicatorDidFailWithError:(NSError *)error;

@end
