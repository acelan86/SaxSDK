//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAXSCGIFImageFrame : NSObject


@end

@interface SAXSCGIFImageView : UIImageView
@property (nonatomic, strong) NSTimer* timer;
- (void)setData:(NSData*)imageData;
@end


