//
//  RZPaas.m
//  RZPaasClion
//
//  Created by yxibng on 2020/11/3.
//

#import "RZPaas.h"
#import "RZPaasCxx.h"

@interface RZPaas()
{
    RZPaasCxx _cxx;
}
@end

@implementation RZPaas

- (void)enableLocalVideo {
    _cxx.enableLocalVideo(true);
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)enableLocalAudio {
    _cxx.enableLocalAudio(true);
    NSLog(@"%s",__FUNCTION__);
}


@end
