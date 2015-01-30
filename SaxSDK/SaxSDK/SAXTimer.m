//
//  SAXTimer.m
//  MoPub
//
//  Created by Andrew He on 3/8/11.
//  Copyright 2011 MoPub, Inc. All rights reserved.
//

#import "SAXTimer.h"
#import "SAXLogging.h"

@interface SAXTimer ()
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *pauseDate;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) NSTimeInterval secondsLeft;

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@end


@implementation SAXTimer

@synthesize timeInterval = _timeInterval;
@synthesize timer = _timer;
@synthesize pauseDate = _pauseDate;
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize isPaused = _isPaused;
@synthesize secondsLeft = _secondsLeft;

+ (SAXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                            target:(id)target
                          selector:(SEL)aSelector
                           repeats:(BOOL)repeats
{
    SAXTimer *timer = [[SAXTimer alloc] init];
    timer.target = target;
    timer.selector = aSelector;
    timer.timer = [NSTimer timerWithTimeInterval:seconds
                                      target:timer
                                    selector:@selector(timerDidFire)
                                    userInfo:nil
                                     repeats:repeats];
    timer.timeInterval = seconds;
    return timer;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    self.pauseDate = nil;
}

- (void)timerDidFire
{
    SuppressPerformSelectorLeakWarning(
        [self.target performSelector:self.selector]
    );
}

- (BOOL)isValid
{
    return [self.timer isValid];
}

- (void)invalidate
{
    self.target = nil;
    self.selector = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)isScheduled
{
    if (!self.timer) {
        return NO;
    }
    CFRunLoopRef runLoopRef = [[NSRunLoop currentRunLoop] getCFRunLoop];
    return CFRunLoopContainsTimer(runLoopRef, (__bridge CFRunLoopTimerRef)(self.timer), kCFRunLoopDefaultMode);
}

- (BOOL)scheduleNow
{
    if (![self.timer isValid])
    {
        SAXLogDebug(@"Could not schedule invalidated SAXTimer (%p).", self);
        return NO;
    }

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    return YES;
}

- (BOOL)pause
{
    if (self.isPaused)
    {
        SAXLogDebug(@"No-op: tried to pause an SAXTimer (%p) that was already paused.", self);
        return NO;
    }

    if (![self.timer isValid])
    {
        SAXLogDebug(@"Cannot pause invalidated SAXTimer (%p).", self);
        return NO;
    }

    if (![self isScheduled])
    {
        SAXLogDebug(@"No-op: tried to pause an SAXTimer (%p) that was never scheduled.", self);
        return NO;
    }

    NSDate *fireDate = [self.timer fireDate];
    self.pauseDate = [NSDate date];
    self.secondsLeft = [fireDate timeIntervalSinceDate:self.pauseDate];
    if (self.secondsLeft <= 0)
    {
        SAXLogWarn(@"An SAXTimer was somehow paused after it was supposed to fire.");
        self.secondsLeft = 5;
    }
    else SAXLogDebug(@"Paused SAXTimer (%p) %.1f seconds left before firing.", self, self.secondsLeft);

    // Pause the timer by setting its fire date far into the future.
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isPaused = YES;

    return YES;
}

- (BOOL)resume
{
    if (![self.timer isValid])
    {
        SAXLogDebug(@"Cannot resume invalidated SAXTimer (%p).", self);
        return NO;
    }

    if (!self.isPaused)
    {
        SAXLogDebug(@"No-op: tried to resume an SAXTimer (%p) that was never paused.", self);
        return NO;
    }

    SAXLogDebug(@"Resumed SAXTimer (%p), should fire in %.1f seconds.", self, self.secondsLeft);

    // Resume the timer.
    NSDate *newFireDate = [NSDate dateWithTimeInterval:self.secondsLeft sinceDate:[NSDate date]];
    [self.timer setFireDate:newFireDate];

    if (![self isScheduled])
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

    self.isPaused = NO;
    return YES;
}

- (NSTimeInterval)initialTimeInterval
{
    return self.timeInterval;
}

@end

