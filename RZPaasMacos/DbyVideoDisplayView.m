//
//  DbyVideoDisplayView.m
//  DbyPaas_iOS
//
//  Created by yxibng on 2019/10/16.
//

#import "DbyVideoDisplayView.h"

@interface DbyVideoDisplayView ()
@property (nonatomic, strong) AVSampleBufferDisplayLayer *displayLayer;

@end


@implementation DbyVideoDisplayView

- (void)dealloc
{
    
}


#if TARGET_OS_IOS

+ (Class)layerClass
{
    return [AVSampleBufferDisplayLayer class];
}

#elif TARGET_OS_OSX

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.wantsLayer = true;
    self.layer = [[AVSampleBufferDisplayLayer alloc] init];
}
#endif

- (AVSampleBufferDisplayLayer *)displayLayer
{
    return (AVSampleBufferDisplayLayer *)self.layer;
}

- (void)setGravity:(AVLayerVideoGravity)gravity
{
    if ([NSThread isMainThread]) {
        self.displayLayer.videoGravity = gravity;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.displayLayer.videoGravity = gravity;
        });
    }
}

- (void)setCanvas:(VIEW_CLASS *)canvas
{
    _canvas = canvas;
    if ([NSThread isMainThread]) {
        [self addToSuperView:canvas];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addToSuperView:canvas];
        });
    }
}


- (void)addToSuperView:(VIEW_CLASS *)view
{
    [self removeFromSuperview];
    if (!view) {
        return;
    }

    [view addSubview:self];
    self.frame = view.bounds;

#if TARGET_OS_IOS
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
#elif TARGET_OS_OSX
    self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
#endif
}



- (void)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    [self displayPixelBuffer:pixelBuffer];
}

#pragma mark -

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    if (!pixelBuffer) {
        return;
    }

    if (self.mirrored) {
        //TODO: 处理数据需要镜像， 可以调用 libyuv 的镜像方法，对数据进行处理
    }
    
    CVPixelBufferRetain(pixelBuffer);
    CMSampleBufferRef sampleBuffer = [self createSampleBufferWithPixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);

    if (!sampleBuffer) {
        return;
    }

    [self displaySampleBuffer:sampleBuffer];
    CFRelease(sampleBuffer);
}

- (CMSampleBufferRef)createSampleBufferWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    if (!pixelBuffer) {
        return NULL;
    }

    //不设置具体时间信息
    CMSampleTimingInfo timing = {kCMTimeInvalid, kCMTimeInvalid, kCMTimeInvalid};
    //获取视频信息
    CMVideoFormatDescriptionRef videoInfo = NULL;
    OSStatus result = CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixelBuffer, &videoInfo);
    NSParameterAssert(result == 0 && videoInfo != NULL);
    if (result != 0) {
        return NULL;
    }

    CMSampleBufferRef sampleBuffer = NULL;
    result = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, true, NULL, NULL, videoInfo, &timing, &sampleBuffer);
    NSParameterAssert(result == 0 && sampleBuffer != NULL);
    CFRelease(videoInfo);
    if (result != 0) {
        return NULL;
    }
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
    CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
    CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);

    return sampleBuffer;
}

- (void)displaySampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if (sampleBuffer == NULL) {
        return;
    }
    CFRetain(sampleBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.displayLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            [self.displayLayer flush];
        }
        if (!self.window) {
            //如果当前视图不再window上，就不要显示了
            CFRelease(sampleBuffer);
            return;
        }

        if (self.displayLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            //此时无法将sampleBuffer加入队列，强行往队列里面添加，会造成崩溃
            CFRelease(sampleBuffer);
            return;
        }

        [self.displayLayer enqueueSampleBuffer:sampleBuffer];
        CFRelease(sampleBuffer);
    });
}

- (void)setMirrored:(BOOL)mirrored
{
    _mirrored = mirrored;
}

@end
