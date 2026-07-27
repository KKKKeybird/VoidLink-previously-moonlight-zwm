#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VLTVResolution) {
    VLTVResolution720p = 0,
    VLTVResolution1080p = 1,
    VLTVResolution4K = 2,
    VLTVResolution1440p = 3,
};

typedef NS_ENUM(NSInteger, VLTVCodec) {
    VLTVCodecAuto = 0,
    VLTVCodecH264 = 1,
    VLTVCodecHEVC = 2,
    VLTVCodecAV1 = 3,
};

typedef NS_ENUM(NSInteger, VLTVRenderingBackend) {
    VLTVRenderingBackendAVSampleBuffer = 0,
    VLTVRenderingBackendMetal = 1,
};

typedef NS_ENUM(NSInteger, VLTVFramePacingMode) {
    VLTVFramePacingOff = 0,
    VLTVFramePacingBalanced = 1,
    VLTVFramePacingSmoothest = 2,
};

@interface TVSettingsStore : NSObject

@property(class, nonatomic, readonly) TVSettingsStore *sharedStore;

- (void)registerDefaults;
- (NSInteger)integerForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;

@end

FOUNDATION_EXPORT NSString *const VLTVSettingResolution;
FOUNDATION_EXPORT NSString *const VLTVSettingFramerate;
FOUNDATION_EXPORT NSString *const VLTVSettingBitrate;
FOUNDATION_EXPORT NSString *const VLTVSettingAudioConfig;
FOUNDATION_EXPORT NSString *const VLTVSettingPreferredCodec;
FOUNDATION_EXPORT NSString *const VLTVSettingEnableHDR;
FOUNDATION_EXPORT NSString *const VLTVSettingEnableYUV444;
FOUNDATION_EXPORT NSString *const VLTVSettingFullColorRange;
FOUNDATION_EXPORT NSString *const VLTVSettingRenderingBackend;
FOUNDATION_EXPORT NSString *const VLTVSettingFramePacingMode;
FOUNDATION_EXPORT NSString *const VLTVSettingFrameQueueSize;
FOUNDATION_EXPORT NSString *const VLTVSettingStatsOverlayLevel;
FOUNDATION_EXPORT NSString *const VLTVSettingEnableGraphs;
FOUNDATION_EXPORT NSString *const VLTVSettingPlayAudioOnPC;
FOUNDATION_EXPORT NSString *const VLTVSettingOptimizeGames;
FOUNDATION_EXPORT NSString *const VLTVSettingMultipleControllers;
FOUNDATION_EXPORT NSString *const VLTVSettingSwapABXY;
FOUNDATION_EXPORT NSString *const VLTVSettingButtonFeedback;
FOUNDATION_EXPORT NSString *const VLTVSettingGyroMode;
FOUNDATION_EXPORT NSString *const VLTVSettingEmulatedControllerType;
FOUNDATION_EXPORT NSString *const VLTVSettingMapControllerToMouse;
FOUNDATION_EXPORT NSString *const VLTVSettingControllerMouseVelocity;
FOUNDATION_EXPORT NSString *const VLTVSettingControllerMouseExpo;

NS_ASSUME_NONNULL_END
