#import "TVFeatureCapabilities.h"

#import <AVFoundation/AVFoundation.h>
#import <GameController/GameController.h>
#import <UIKit/UIKit.h>
#import <VideoToolbox/VideoToolbox.h>
#import <sys/utsname.h>

@implementation TVFeatureCapabilities

+ (BOOL)supports4K {
    struct utsname systemInfo;
    uname(&systemInfo);
    return strcmp(systemInfo.machine, "AppleTV5,3") != 0;
}

+ (BOOL)supportsHDR {
    return (AVPlayer.availableHDRModes & AVPlayerHDRModeHDR10) != 0;
}

+ (BOOL)supportsAV1HardwareDecoding {
    const CMVideoCodecType av1Codec = 'av01';
    return VTIsHardwareDecodeSupported(av1Codec);
}

+ (NSInteger)maximumFramesPerSecond {
    return MAX(30, UIScreen.mainScreen.maximumFramesPerSecond);
}

+ (NSInteger)maximumAudioChannels {
    NSInteger channels = AVAudioSession.sharedInstance.maximumOutputNumberOfChannels;
    return MAX(channels, 2);
}

+ (BOOL)hasExtendedGamepad {
    for (GCController *controller in GCController.controllers) {
        if (controller.extendedGamepad != nil) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)hasMotionController {
    for (GCController *controller in GCController.controllers) {
        if (controller.extendedGamepad != nil && controller.motion != nil) {
            return YES;
        }
    }
    return NO;
}

@end
