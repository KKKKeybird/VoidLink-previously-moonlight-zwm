#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVFeatureCapabilities : NSObject

@property(class, nonatomic, readonly) BOOL supports4K;
@property(class, nonatomic, readonly) BOOL supportsHDR;
@property(class, nonatomic, readonly) BOOL supportsAV1HardwareDecoding;
@property(class, nonatomic, readonly) NSInteger maximumFramesPerSecond;
@property(class, nonatomic, readonly) NSInteger maximumAudioChannels;
@property(class, nonatomic, readonly) BOOL hasExtendedGamepad;
@property(class, nonatomic, readonly) BOOL hasMotionController;

@end

NS_ASSUME_NONNULL_END
