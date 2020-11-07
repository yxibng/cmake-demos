//
//  DbyVideoDisplayView.h
//  DbyPaas_iOS
//
//  Created by yxibng on 2019/10/16.
//
#import <AppKit/AppKit.h>
#import <CoreVideo/CoreVideo.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DbyVideoDisplayView : NSView

@property (nonatomic, weak) VIEW_CLASS *canvas;
@property (nonatomic, copy) AVLayerVideoGravity gravity;
@property (nonatomic, assign) BOOL mirrored;

/**
 绘制nv12数据，如果需要镜像，内部会做镜像处理
 */
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
