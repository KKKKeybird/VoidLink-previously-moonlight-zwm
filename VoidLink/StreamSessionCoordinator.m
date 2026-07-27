#import "StreamSessionCoordinator.h"

#import <GameController/GameController.h>

#import "HttpManager.h"
#import "StreamConfiguration.h"
#import "TemporarySettings.h"

#if TARGET_OS_TV
#import "TVFeatureCapabilities.h"
#endif

NSErrorDomain const VLStreamSessionErrorDomain = @"com.voidlink.stream-session";

@implementation StreamSessionCoordinator

- (instancetype)initWithHosts:(NSArray *)hosts
            discoveryCallback:(id<DiscoveryCallback>)discoveryCallback {
    self = [super init];
    if (self) {
        _discoveryManager = [[DiscoveryManager alloc] initWithHosts:hosts
                                                       andCallback:discoveryCallback];
    }
    return self;
}

- (void)enqueuePairingWithHTTPManager:(HttpManager *)httpManager
                           clientCert:(NSData *)clientCert
                             callback:(id<PairCallback>)callback
                       operationQueue:(NSOperationQueue *)operationQueue {
    PairManager *pairing = [[PairManager alloc] initWithManager:httpManager
                                                    clientCert:clientCert
                                                      callback:callback];
    [operationQueue addOperation:pairing];
}

- (BOOL)canStartStreamingWithError:(NSError **)error {
#if TARGET_OS_TV
    if (!TVFeatureCapabilities.hasExtendedGamepad) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:VLStreamSessionErrorDomain
                                         code:1
                                     userInfo:@{
                NSLocalizedDescriptionKey: @"开始串流前，请连接带摇杆和扳机键的实体手柄。Siri Remote 仅用于 VoidLink TV 菜单。"
            }];
        }
        return NO;
    }
#endif
    return YES;
}

- (void)finalizeStreamConfiguration:(StreamConfiguration *)configuration
                           settings:(TemporarySettings *)settings {
#if TARGET_OS_TV
    configuration.enablePIP = NO;
    configuration.redirectMic = NO;
    configuration.asyncNativeTouchPriority = NO;

    if (!TVFeatureCapabilities.supports4K && configuration.height >= 2160) {
        configuration.width = 1920;
        configuration.height = 1080;
    }
    configuration.frameRate = (int)MIN(configuration.frameRate,
                                       TVFeatureCapabilities.maximumFramesPerSecond);
    if (!TVFeatureCapabilities.hasMotionController) {
        configuration.gyroMode = 0;
    }
#else
    (void)configuration;
    (void)settings;
#endif
}

@end
