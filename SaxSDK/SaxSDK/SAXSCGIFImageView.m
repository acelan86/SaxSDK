//
//  SCGIFImageView.m
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SAXSCGIFImageView.h"
#import "SAXLogging.h"
#import <ImageIO/ImageIO.h>

@interface SAXSCGIFImageFrame()
@property (nonatomic) double duration;
@property (nonatomic, strong) UIImage* image;
@end

@implementation SAXSCGIFImageFrame

//@synthesize image = _image;
//@synthesize duration = _duration;

-(void)dealloc {
    SAXLogDebug(@"SAXSCGIFImageFrame dealloc.");
}


@end

@interface SAXSCGIFImageView ()

@property (nonatomic) NSInteger currentImageIndex;
@property (nonatomic, strong) NSMutableArray* imageFrameArray;


//Setting this value to pause or continue animation;
@property (nonatomic) BOOL animating;

- (void)resetTimer;
- (void)showNextImage;

@end

@implementation SAXSCGIFImageView
@synthesize imageFrameArray = _imageFrameArray;
@synthesize timer = _timer;
@synthesize animating = _animating;



- (void)resetTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)setData:(NSData *)imageData {
    if (!imageData) {
        return;
    }
    [self resetTimer];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (size_t i = 0; i < count; i++) {
        SAXSCGIFImageFrame* gifImage = [[SAXSCGIFImageFrame alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        gifImage.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CFDictionaryRef cfDic = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary* frameProperties = (__bridge NSDictionary*)cfDic;
        
        //先读kCGImagePropertyGIFUnclampedDelayTime，然后再读kCGImagePropertyGIFDelayTime
        if([[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime]) {
            gifImage.duration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime] doubleValue];
        }else {
            gifImage.duration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        }
        
        gifImage.duration = MAX(gifImage.duration, 0.01);
//
        [tmpArray addObject:gifImage];
        
        CFRelease(cfDic);
        CGImageRelease(image);
    }
    CFRelease(source);
    
    self.imageFrameArray = nil;
    if (tmpArray.count > 1) {
        self.imageFrameArray = tmpArray;
        _currentImageIndex = -1;
        _animating = YES;
        [self showNextImage];
    } else {
        self.image = [UIImage imageWithData:imageData];
    }
}

- (void):(UIImage *)image {
    [super setImage:image];
    [self resetTimer];
    self.imageFrameArray = nil;
    _animating = NO;
}

- (void)showNextImage {
    if (!_animating) {
        return;
    }
    if ([_imageFrameArray count] == 0) {
        return ;
    }
/**支持循环播放 begin **/
//    _currentImageIndex = ++_currentImageIndex % _imageFrameArray.count;
    
//    SAXSCGIFImageFrame* gifImage = [[SAXSCGIFImageFrame alloc] init];
//    SAXSCGIFImageFrame *tmp =  [_imageFrameArray objectAtIndex:_currentImageIndex];
//    gifImage.image = [UIImage imageWithData:UIImagePNGRepresentation([tmp image])];
//    gifImage.duration = gifImage.duration;
/**支持循环播放 end **/
    
    SAXSCGIFImageFrame* gifImage = [_imageFrameArray objectAtIndex:0];
    [super setImage:[gifImage image]];
    [_imageFrameArray removeObjectAtIndex:0];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:gifImage.duration target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
}

- (void)setAnimating:(BOOL)animating {
    if (_imageFrameArray.count < 2) {
        _animating = animating;
        return;
    }
    
    if (!_animating && animating) {
        //continue
        _animating = animating;
        if (!_timer) {
            [self showNextImage];
        }
    } else if (_animating && !animating) {
        //stop
        _animating = animating;
        [self resetTimer];
    }
}

-(void)dealloc {
    SAXLogDebug(@"SAXSCGIFImageView dealloc.");
}

@end
