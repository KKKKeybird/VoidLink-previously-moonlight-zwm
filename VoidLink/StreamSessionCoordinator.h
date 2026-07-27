#import <Foundation/Foundation.h>

#import "DiscoveryManager.h"
#import "PairManager.h"

@class HttpManager;
@class StreamConfiguration;
@class TemporarySettings;

NS_ASSUME_NONNULL_BEGIN

/// Owns the platform-neutral discovery and pairing operations used by each UI.
/// View controllers remain responsible only for presentation and navigation.
@interface StreamSessionCoordinator : NSObject

@property(nonatomic, readonly) DiscoveryManager *discoveryManager;

- (instancetype)initWithHosts:(NSArray *)hosts
            discoveryCallback:(id<DiscoveryCallback>)discoveryCallback;

- (void)enqueuePairingWithHTTPManager:(HttpManager *)httpManager
                           clientCert:(NSData *)clientCert
                             callback:(id<PairCallback>)callback
                       operationQueue:(NSOperationQueue *)operationQueue;

- (BOOL)canStartStreamingWithError:(NSError * _Nullable * _Nullable)error;
- (void)finalizeStreamConfiguration:(StreamConfiguration *)configuration
                           settings:(TemporarySettings *)settings;

@end

FOUNDATION_EXPORT NSErrorDomain const VLStreamSessionErrorDomain;

NS_ASSUME_NONNULL_END
