#import "TVSettingsStore.h"

NSString *const VLTVSettingResolution = @"streamResolution";
NSString *const VLTVSettingFramerate = @"framerate";
NSString *const VLTVSettingBitrate = @"bitrate";
NSString *const VLTVSettingAudioConfig = @"audioConfig";
NSString *const VLTVSettingPreferredCodec = @"preferredCodec";
NSString *const VLTVSettingEnableHDR = @"enableHdr";
NSString *const VLTVSettingEnableYUV444 = @"enableYUV444";
NSString *const VLTVSettingFullColorRange = @"fullColorRange";
NSString *const VLTVSettingRenderingBackend = @"renderingBackend";
NSString *const VLTVSettingFramePacingMode = @"framePacingMode";
NSString *const VLTVSettingFrameQueueSize = @"frameQueueSize";
NSString *const VLTVSettingStatsOverlayLevel = @"statsOverlayLevel";
NSString *const VLTVSettingEnableGraphs = @"enableGraphs";
NSString *const VLTVSettingPlayAudioOnPC = @"audioOnPC";
NSString *const VLTVSettingOptimizeGames = @"optimizeGames";
NSString *const VLTVSettingMultipleControllers = @"multipleControllers";
NSString *const VLTVSettingSwapABXY = @"swapABXYButtons";
NSString *const VLTVSettingButtonFeedback = @"buttonVisualFeedback";
NSString *const VLTVSettingGyroMode = @"gyroMode";
NSString *const VLTVSettingEmulatedControllerType = @"emulatedControllerType";
NSString *const VLTVSettingMapControllerToMouse = @"mapControllerToMouse";
NSString *const VLTVSettingControllerMouseVelocity = @"controllerMousePointerVelocity";
NSString *const VLTVSettingControllerMouseExpo = @"controllerMouseExpo";

@implementation TVSettingsStore

+ (TVSettingsStore *)sharedStore {
    static TVSettingsStore *store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[TVSettingsStore alloc] init];
        [store registerDefaults];
    });
    return store;
}

- (void)registerDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        VLTVSettingResolution: @(VLTVResolution1080p),
        VLTVSettingFramerate: @60,
        VLTVSettingBitrate: @20000,
        VLTVSettingAudioConfig: @2,
        VLTVSettingPreferredCodec: @(VLTVCodecAuto),
        VLTVSettingEnableHDR: @NO,
        VLTVSettingEnableYUV444: @NO,
        VLTVSettingFullColorRange: @NO,
        VLTVSettingRenderingBackend: @(VLTVRenderingBackendMetal),
        VLTVSettingFramePacingMode: @(VLTVFramePacingSmoothest),
        VLTVSettingFrameQueueSize: @3,
        VLTVSettingStatsOverlayLevel: @0,
        VLTVSettingEnableGraphs: @NO,
        VLTVSettingPlayAudioOnPC: @NO,
        VLTVSettingOptimizeGames: @YES,
        VLTVSettingMultipleControllers: @YES,
        VLTVSettingSwapABXY: @NO,
        VLTVSettingButtonFeedback: @NO,
        VLTVSettingGyroMode: @0,
        VLTVSettingEmulatedControllerType: @0,
        VLTVSettingMapControllerToMouse: @NO,
        VLTVSettingControllerMouseVelocity: @100,
        VLTVSettingControllerMouseExpo: @100,
    }];
}

- (NSInteger)integerForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

@end
