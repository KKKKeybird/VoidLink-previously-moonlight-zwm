//
//  TemporarySettings.m
//  Moonlight
//
//  Created by Cameron Gutman on 12/1/15.
//  Copyright © 2015 Moonlight Stream. All rights reserved.
//
//  Modified by True砖家 since 2024.6.1
//  Copyright © 2024 True砖家 @ Bilibili. All rights reserved.
//

#import "TemporarySettings.h"
#import "OnScreenControls.h"
#if TARGET_OS_TV
#import "TVFeatureCapabilities.h"
#import "TVSettingsStore.h"
#endif

@implementation TemporarySettings

- (id) initFromSettings:(Settings*)settings {
    self = [self init];
    
    self.parent = settings;
    
#if TARGET_OS_TV
    TVSettingsStore *store = TVSettingsStore.sharedStore;
    self.bitrate = @([store integerForKey:VLTVSettingBitrate]);
    self.framerate = @(MIN([store integerForKey:VLTVSettingFramerate],
                           TVFeatureCapabilities.maximumFramesPerSecond));
    self.audioConfig = @(MIN([store integerForKey:VLTVSettingAudioConfig],
                             TVFeatureCapabilities.maximumAudioChannels));
    self.preferredCodec = (typeof(self.preferredCodec))[store integerForKey:VLTVSettingPreferredCodec];
    if (self.preferredCodec == CODEC_PREF_AV1 && !TVFeatureCapabilities.supportsAV1HardwareDecoding) {
        self.preferredCodec = CODEC_PREF_AUTO;
    }
    self.enableYUV444 = [store boolForKey:VLTVSettingEnableYUV444];
    self.enablePIP = NO;
    self.fullColorRange = [store boolForKey:VLTVSettingFullColorRange];
    self.frameQueueSize = @([store integerForKey:VLTVSettingFrameQueueSize]);
    self.playAudioOnPC = [store boolForKey:VLTVSettingPlayAudioOnPC];
    self.enableHdr = TVFeatureCapabilities.supportsHDR && [store boolForKey:VLTVSettingEnableHDR];
    self.optimizeGames = [store boolForKey:VLTVSettingOptimizeGames];
    self.multiController = [store boolForKey:VLTVSettingMultipleControllers];
    self.swapABXYButtons = [store boolForKey:VLTVSettingSwapABXY];
    self.buttonVisualFeedback = [store boolForKey:VLTVSettingButtonFeedback];
    self.gyroMode = @([store integerForKey:VLTVSettingGyroMode]);
    self.emulatedControllerType = @([store integerForKey:VLTVSettingEmulatedControllerType]);
    self.statsOverlayLevel = @([store integerForKey:VLTVSettingStatsOverlayLevel]);
    self.statsOverlayEnabled = self.statsOverlayLevel.integerValue != 0;
    self.enableGraphs = [store boolForKey:VLTVSettingEnableGraphs];
    self.graphOpacity = @100;
    self.renderingBackend = @([store integerForKey:VLTVSettingRenderingBackend]);
    self.framePacingMode = @([store integerForKey:VLTVSettingFramePacingMode]);
    self.mapControllerToMouse = [store boolForKey:VLTVSettingMapControllerToMouse];
    self.controllerMousePointerVelocity = @([store integerForKey:VLTVSettingControllerMouseVelocity]);
    self.controllerMouseExpo = @([store integerForKey:VLTVSettingControllerMouseExpo]);

    // Features that rely on touch, a physical pointer, microphone capture, or
    // background playback are deliberately unavailable on tvOS.
    self.redirectMic = NO;
    self.useBuiltinMic = NO;
    self.btMouseSupport = NO;
    self.touchPointTracking = NO;
    self.enablePinch = NO;
    self.passthroughGestures = NO;
    self.onscreenControls = @(OnScreenControlsLevelOff);

    NSInteger _screenSize = [store integerForKey:VLTVSettingResolution];
    if (_screenSize == VLTVResolution4K && !TVFeatureCapabilities.supports4K) {
        _screenSize = VLTVResolution1080p;
    }
    switch (_screenSize) {
        case VLTVResolution720p:
            self.height = @720;
            self.width = @1280;
            break;
        case VLTVResolution1080p:
            self.height = @1080;
            self.width = @1920;
            break;
        case VLTVResolution4K:
            self.height = @2160;
            self.width = @3840;
            break;
        case VLTVResolution1440p:
            self.height = @1440;
            self.width = @2560;
            break;
        default:
            self.height = @1080;
            self.width = @1920;
            break;
    }
#else
    self.settingsMenuMode = settings.settingsMenuMode;
    self.settingsMenuWidth = settings.settingsMenuWidth;
    self.bitrate = settings.bitrate;
    self.framerate = settings.framerate;
    self.height = settings.height;
    self.width = settings.width;
    self.audioConfig = settings.audioConfig;
    self.preferredCodec = settings.preferredCodec;
    self.enableYUV444 = settings.enableYUV444;
    self.sdrPerformanceWorkaround = settings.sdrPerformanceWorkaround;
    self.enablePIP = settings.enablePIP;
    self.fullColorRange = settings.fullColorRange;
    self.frameQueueSize = settings.frameQueueSize;
    self.enableFrameTimebase  = settings.enableFrameTimebase;
    self.asyncFrameDequeue = settings.asyncFrameDequeue;
    self.playAudioOnPC = settings.playAudioOnPC;
    self.redirectMic = settings.redirectMic;
    self.useBuiltinMic = settings.useBuiltinMic;
    self.enableHdr = settings.enableHdr;
    self.optimizeGames = settings.optimizeGames;
    self.multiController = settings.multiController;
    self.buttonVisualFeedback = settings.buttonVisualFeedback;
    self.touchPointTracking = settings.touchPointTracking;
    self.swapABXYButtons = settings.swapABXYButtons;
    self.onscreenControls = settings.onscreenControls;
    self.gyroMode = settings.gyroMode;
    self.emulatedControllerType = settings.emulatedControllerType;
    self.reverseMouseWheelDirection = settings.reverseMouseWheelDirection;
    self.asyncNativeTouchPriority = settings.asyncNativeTouchPriority;
    self.btMouseSupport = settings.btMouseSupport;
    // self.absoluteTouchMode = settings.absoluteTouchMode;
    self.touchMode = settings.touchMode;
    self.statsOverlayLevel = settings.statsOverlayLevel;
    self.statsOverlayEnabled = settings.statsOverlayEnabled;
    self.keyboardToggleFingers = settings.keyboardToggleFingers;
    self.oscLayoutToolFingers = settings.oscLayoutToolFingers;
    self.slideToSettingsScreenEdge = settings.slideToSettingsScreenEdge;
    self.slideToSettingsDistance = settings.slideToSettingsDistance;
    self.liftStreamViewForKeyboard = settings.liftStreamViewForKeyboard;
    self.showKeyboardToolbar = settings.showKeyboardToolbar;
    self.softKeyboardHeight = settings.softKeyboardHeight;
    self.touchMoveEventInterval = settings.touchMoveEventInterval;
    self.touchPointerVelocityFactor = settings.touchPointerVelocityFactor;
    self.mousePointerVelocityFactor = settings.mousePointerVelocityFactor;
    self.gyroSensitivity = settings.gyroSensitivity;
    self.localVolume = settings.localVolume;
    self.micVolume = settings.micVolume;
    self.pointerVelocityModeDivider = settings.pointerVelocityModeDivider;
    self.unlockDisplayOrientation = settings.unlockDisplayOrientation;
    self.resolutionSelected = settings.resolutionSelected;
    self.externalDisplayMode = settings.externalDisplayMode;
    self.localMousePointerMode = settings.localMousePointerMode;
    self.enableGraphs = settings.enableGraphs;
    self.graphOpacity = settings.graphOpacity;
    self.renderingBackend = settings.renderingBackend;
    self.framePacingMode = settings.framePacingMode;
    self.sendDummyEvent = settings.sendDummyEvent;
    self.rememberFoldState = settings.rememberFoldState;
    self.gyroBiasX = settings.gyroBiasX;
    self.gyroBiasY = settings.gyroBiasY;
    self.gyroBiasZ = settings.gyroBiasZ;
    self.controllerGyroBiasX = settings.controllerGyroBiasX;
    self.controllerGyroBiasY = settings.controllerGyroBiasY;
    self.controllerGyroBiasZ = settings.controllerGyroBiasZ;
    self.singleTapSensitivity = settings.singleTapSensitivity;
    self.backgroundSessionTimer = settings.backroundSessionTimer;
    self.edgeSlidingSensitivity = settings.edgeSlidingSensitivity;
    self.appTheme = settings.appTheme;
    self.hapticEngine = settings.hapticEngine;
    self.uniqueId = settings.uniqueId;
    self.audioEngine = settings.audioEngine;
    self.delayLeftClick = settings.delayLeftClick;
    self.duckOtherApps = settings.duckOtherApps;
    self.muteInBackground = settings.muteInBackground;
    self.relativeTouchSlideThreshold = settings.relativeTouchSlideThreshold;
    self.enablePinch = settings.enablePinch;
    self.scrollSensitivity = settings.scrollSensitivity;
    self.pinchSensitivity = settings.pinchSensitivity;
    self.leftClickDelayMs = settings.leftClickDelayMs;
    self.ctrlDownForPinch = settings.ctrlDownForPinch;
    self.settingsMenuOffset = settings.settingsMenuOffset;
    self.passthroughGestures = settings.passthroughGestures;
    self.mapControllerToMouse = settings.mapControllerToMouse;
    self.controllerMouseLeftButton = settings.controllerMouseLeftButton;
    self.controllerMouseRightButton = settings.controllerMouseRightButton;
    self.controllerMouseSwitch = settings.controllerMouseSwitch;
    self.controllerMouseStick = settings.controllerMouseStick;
    self.controllerMousePointerVelocity = settings.controllerMousePointerVelocity;
    self.controllerMouseExpo = settings.controllerMouseExpo;
    self.globeAsEscape = settings.globeAsEscape;
    
    // Pencil settings:
    self.pencilTickMode = settings.pencilTickMode;
    self.pencilTickIntervalUs = settings.pencilTickIntervalUs;

#endif
    
    return self;
}

@end
