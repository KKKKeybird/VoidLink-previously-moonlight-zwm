#import "TVSettingsViewController.h"

#import "TVFeatureCapabilities.h"
#import "TVSettingsStore.h"

typedef NS_ENUM(NSInteger, VLTVSettingKind) {
    VLTVSettingKindChoice,
    VLTVSettingKindToggle,
};

@interface VLTVSettingItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *key;
@property(nonatomic) VLTVSettingKind kind;
@property(nonatomic, copy) NSArray<NSString *> *titles;
@property(nonatomic, copy) NSArray<NSNumber *> *values;
@property(nonatomic) BOOL enabled;
@end

@implementation VLTVSettingItem
@end

@interface TVSettingsViewController ()
@property(nonatomic, copy) NSArray<NSString *> *sectionTitles;
@property(nonatomic, copy) NSArray<NSArray<VLTVSettingItem *> *> *sections;
@property(nonatomic, strong) TVSettingsStore *settings;
@end

@implementation TVSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VoidLink TV 设置";
    self.settings = TVSettingsStore.sharedStore;
    self.tableView.backgroundColor = UIColor.blackColor;
    [self buildSections];
}

- (VLTVSettingItem *)choice:(NSString *)title
                        key:(NSString *)key
                     titles:(NSArray<NSString *> *)titles
                     values:(NSArray<NSNumber *> *)values
                    enabled:(BOOL)enabled {
    VLTVSettingItem *item = [[VLTVSettingItem alloc] init];
    item.title = title;
    item.key = key;
    item.kind = VLTVSettingKindChoice;
    item.titles = titles;
    item.values = values;
    item.enabled = enabled;
    return item;
}

- (VLTVSettingItem *)toggle:(NSString *)title key:(NSString *)key enabled:(BOOL)enabled {
    VLTVSettingItem *item = [[VLTVSettingItem alloc] init];
    item.title = title;
    item.key = key;
    item.kind = VLTVSettingKindToggle;
    item.enabled = enabled;
    return item;
}

- (void)buildSections {
    NSMutableArray *resTitles = [NSMutableArray arrayWithArray:@[@"720p", @"1080p", @"1440p"]];
    NSMutableArray *resValues = [NSMutableArray arrayWithArray:@[@(VLTVResolution720p), @(VLTVResolution1080p), @(VLTVResolution1440p)]];
    if (TVFeatureCapabilities.supports4K) {
        [resTitles addObject:@"4K"];
        [resValues addObject:@(VLTVResolution4K)];
    }

    NSMutableArray *codecTitles = [NSMutableArray arrayWithArray:@[@"自动", @"H.264", @"HEVC"]];
    NSMutableArray *codecValues = [NSMutableArray arrayWithArray:@[@(VLTVCodecAuto), @(VLTVCodecH264), @(VLTVCodecHEVC)]];
    if (TVFeatureCapabilities.supportsAV1HardwareDecoding) {
        [codecTitles addObject:@"AV1"];
        [codecValues addObject:@(VLTVCodecAV1)];
    }

    NSMutableArray *audioTitles = [NSMutableArray arrayWithObject:@"立体声"];
    NSMutableArray *audioValues = [NSMutableArray arrayWithObject:@2];
    if (TVFeatureCapabilities.maximumAudioChannels >= 6) {
        [audioTitles addObject:@"5.1 环绕声"];
        [audioValues addObject:@6];
    }
    if (TVFeatureCapabilities.maximumAudioChannels >= 8) {
        [audioTitles addObject:@"7.1 环绕声"];
        [audioValues addObject:@8];
    }

    self.sectionTitles = @[@"视频", @"音频", @"手柄", @"诊断"];
    self.sections = @[
        @[
            [self choice:@"分辨率" key:VLTVSettingResolution titles:resTitles values:resValues enabled:YES],
            [self choice:@"帧率" key:VLTVSettingFramerate titles:@[@"30 FPS", @"60 FPS"] values:@[@30, @60] enabled:YES],
            [self choice:@"比特率"
                     key:VLTVSettingBitrate
                  titles:@[@"10 Mbps", @"20 Mbps", @"40 Mbps", @"80 Mbps", @"100 Mbps",
                           @"150 Mbps", @"200 Mbps", @"300 Mbps", @"400 Mbps", @"500 Mbps",
                           @"600 Mbps", @"700 Mbps", @"800 Mbps"]
                  values:@[@10000, @20000, @40000, @80000, @100000,
                           @150000, @200000, @300000, @400000, @500000,
                           @600000, @700000, @800000]
                 enabled:YES],
            [self choice:@"首选编解码器" key:VLTVSettingPreferredCodec titles:codecTitles values:codecValues enabled:YES],
            [self toggle:@"HDR" key:VLTVSettingEnableHDR enabled:TVFeatureCapabilities.supportsHDR],
            [self toggle:@"YUV 4:4:4" key:VLTVSettingEnableYUV444 enabled:YES],
            [self toggle:@"全色域" key:VLTVSettingFullColorRange enabled:YES],
            [self choice:@"渲染器" key:VLTVSettingRenderingBackend titles:@[@"AVSampleBuffer", @"Metal"] values:@[@0, @1] enabled:YES],
            [self choice:@"帧同步" key:VLTVSettingFramePacingMode titles:@[@"关闭", @"传统", @"队列同步"] values:@[@0, @1, @2] enabled:YES],
            [self choice:@"帧队列" key:VLTVSettingFrameQueueSize titles:@[@"1 帧", @"2 帧", @"3 帧", @"4 帧", @"5 帧"] values:@[@1, @2, @3, @4, @5] enabled:YES],
        ],
        @[
            [self choice:@"音频输出" key:VLTVSettingAudioConfig titles:audioTitles values:audioValues enabled:YES],
            [self toggle:@"在主机上播放声音" key:VLTVSettingPlayAudioOnPC enabled:YES],
        ],
        @[
            [self toggle:@"优化游戏设置" key:VLTVSettingOptimizeGames enabled:YES],
            [self toggle:@"多手柄" key:VLTVSettingMultipleControllers enabled:YES],
            [self toggle:@"交换 A/B 与 X/Y" key:VLTVSettingSwapABXY enabled:YES],
            [self toggle:@"按键视觉反馈" key:VLTVSettingButtonFeedback enabled:YES],
            [self choice:@"模拟手柄类型" key:VLTVSettingEmulatedControllerType titles:@[@"自动", @"Xbox", @"PlayStation", @"Nintendo"] values:@[@0, @1, @2, @3] enabled:YES],
            [self choice:@"手柄体感" key:VLTVSettingGyroMode titles:@[@"关闭", @"自动", @"始终使用手柄"] values:@[@0, @1, @3] enabled:TVFeatureCapabilities.hasMotionController],
            [self toggle:@"手柄映射为鼠标" key:VLTVSettingMapControllerToMouse enabled:YES],
            [self choice:@"手柄鼠标速度" key:VLTVSettingControllerMouseVelocity titles:@[@"50%", @"75%", @"100%", @"125%", @"150%", @"200%"] values:@[@50, @75, @100, @125, @150, @200] enabled:YES],
            [self choice:@"手柄鼠标曲线" key:VLTVSettingControllerMouseExpo titles:@[@"线性", @"柔和", @"平衡", @"激进"] values:@[@100, @125, @150, @200] enabled:YES],
        ],
        @[
            [self choice:@"统计叠加层" key:VLTVSettingStatsOverlayLevel titles:@[@"关闭", @"精简", @"详细"] values:@[@0, @1, @2] enabled:YES],
            [self toggle:@"性能图表" key:VLTVSettingEnableGraphs enabled:YES],
        ],
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"];
    }
    VLTVSettingItem *item = self.sections[indexPath.section][indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightMedium];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:28];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.userInteractionEnabled = item.enabled;
    cell.contentView.alpha = item.enabled ? 1.0 : 0.4;

    if (item.kind == VLTVSettingKindToggle) {
        BOOL enabled = [self.settings boolForKey:item.key];
        cell.detailTextLabel.text = enabled ? @"开" : @"关";
        cell.accessoryType = enabled ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        NSInteger value = [self.settings integerForKey:item.key];
        NSUInteger index = [item.values indexOfObject:@(value)];
        cell.detailTextLabel.text = index == NSNotFound ? @"自动" : item.titles[index];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VLTVSettingItem *item = self.sections[indexPath.section][indexPath.row];
    if (!item.enabled) {
        return;
    }
    if (item.kind == VLTVSettingKindToggle) {
        [self.settings setBool:![self.settings boolForKey:item.key] forKey:item.key];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }

    UIAlertController *picker = [UIAlertController alertControllerWithTitle:item.title
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSUInteger index = 0; index < item.titles.count; index++) {
        [picker addAction:[UIAlertAction actionWithTitle:item.titles[index]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(__unused UIAlertAction *action) {
            [self.settings setInteger:item.values[index].integerValue forKey:item.key];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
    }
    [picker addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
