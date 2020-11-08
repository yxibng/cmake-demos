//
//  DbyVideoDisplayView.h
//  DbyPaas_iOS
//
//  Created by yxibng on 2019/10/16.
//
#import <TargetConditionals.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
typedef UIView VIEW_CLASS;
typedef UIColor COLOR_CLASS;
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
typedef NSView VIEW_CLASS;
typedef NSColor COLOR_CLASS;
#endif

#import <CoreVideo/CoreVideo.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DbyVideoDisplayView : VIEW_CLASS

@property (nonatomic, weak) VIEW_CLASS *canvas;
@property (nonatomic, copy) AVLayerVideoGravity gravity;
@property (nonatomic, assign) BOOL mirrored;

/**
 绘制nv12数据，如果需要镜像，内部会做镜像处理
 */
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
