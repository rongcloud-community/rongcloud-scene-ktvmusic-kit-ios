//
//  RCSViewController.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 06/17/2022.
//  Copyright (c) 2022 彭蕾. All rights reserved.
//

#import "RCSViewController.h"
#import <RCSceneKTVMusicKit/RCSKTVMusicKit.h>
#import <RCSceneBaseKit/RCSBaseKit.h>
#import "RCSReverbItem.h"
#import "RCSScreenTipsView.h"
#import <Masonry/Masonry.h>

@interface RCSViewController ()
<RCSKTVScreenDelegate,
RCSKTVTunerViewControllerDelegate,
RCSKTVTunerViewControllerDataSource,
RCSKTVMusicLibraryDelegate>

@property (nonatomic, assign) CGFloat currentTime;
@property (nonatomic, strong) RCSKTVScreen *screen;
@property (nonatomic, strong) RCSCountdown *readyCountdown;
@property (nonatomic, strong) RCSCountdown *waitCountdown;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) RCSKTVTunerViewController *tuner;
@property (nonatomic, strong) NSArray<id<RCSReverbItemProtocol>> *reverbData;
@property (nonatomic, strong) RCSKTVTunerConfig *tunerConfig;
@property (nonatomic, strong) UIButton *musicListButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) RCSKTVMusicLibrary *musicLibrary;
@property (nonatomic, copy) NSString *currentPlayId;

@end

@implementation RCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];

    [self singTogether];
    
//    [self.musicLibrary fetchSelectedMusicListCompletionBlock:nil];
    
}

/// 测试 hifive krc test
- (void)testHifiveKrcLyricWithMusicId:(NSString *)musicId {
    if (musicId.length == 0) {
        return ;
    }
    [RCSKTVMusicLibrary fetchMusicInfoWithMusicId:musicId
                                  completionBlock:^(id<RCSKTVMusicProtocol>  _Nullable model) {
        NSLog(@"%@", model.dynamicLyricUrl);
        [RCSKTVMusicLibrary downloadFileWithUrl:model.dynamicLyricUrl
                                       progress:^(NSProgress * _Nullable progress) {}
                                     completion:^(NSString * _Nullable localPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [NSURL fileURLWithPath:localPath];
                [self.screen resetScreenWithLyricURL:url
                                                role:RCSKTVScreenRoleLeadSinger];
                [self startPlayingWithRole:RCSKTVScreenRoleAudience];
            });
        }];
    }];
}

// 合唱
- (void)singTogether {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1D653D0C3B8" withExtension:@"lrc"];
    [self.screen resetScreenWithLyricURL:url role:RCSKTVScreenRoleLeadSinger];
    [self startPlayingWithRole:RCSKTVScreenRoleAudience];
}

- (void)startPlayingWithRole:(RCSKTVScreenRole)role {
    [self resetDisplayLink];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - test
- (void)resetDisplayLink {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
        self.currentTime = 0;
    }
    self.displayLink.paused = NO;
}

- (void)rotation:(CADisplayLink *)displayLink {
    self.currentTime += (1.0 / displayLink.preferredFramesPerSecond);
    [self.screen updateScreenWithCurrentTime:self.currentTime];
}

#pragma mark - SETUP SUBVIEWS

- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor rcs_colorWithHex:0x0A013F];
    
    [self.view addSubview:self.screen];
    [self.screen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.inset(15);
        make.top.offset(100);
        make.height.mas_equalTo(188);
    }];
    
    [self.view addSubview:self.musicListButton];
    [self.musicListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screen.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.inset(40);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
}

#pragma mark - PRIVATE METHOD

- (void)presentMusicLibraryViewController {
    [self.musicLibrary showMusicLibraryInViewController:self
                                                   isSolo:YES
                                          seletectedIndex:1
                                                playingId:@""];
}

#pragma mark - screen delegate
- (void)showTuner {
    [self.tuner showIn:self];
}

/// 切歌
- (void)nextSong {
    self.displayLink.paused = NO;
    
    NSURL *simpleLRCUrl = [[NSBundle mainBundle] URLForResource:@"2F0864DEC7" withExtension:@"lrc"];
    [self.screen resetScreenWithLyricURL:simpleLRCUrl role:RCSKTVScreenRoleSinger];
    [self startPlayingWithRole:RCSKTVScreenRoleAudience];
}

/// 播放/暂停 歌曲
/// @param isPlay  yes播放，no 暂停
- (void)play:(BOOL)isPlay {
    self.displayLink.paused = !isPlay;
    /// 如果失败，需要设置回去

}

/// 切换原/伴唱
/// @param origin  yes 原唱，no 伴唱
- (void)turnToOriginSong:(BOOL)origin {
}

#pragma mark - RCSKTVTunerViewController delegate & dataSource
/// 混响音效
- (void)reverbChanged:(NSInteger)index {
    
}

/// 伴奏音量
- (void)accompVolumeChanged:(float)value {
    
}

/// 人声音量
- (void)vocalVolumeChanged:(float)value {
    
}

/// 耳返
- (void)earReturnChanged:(BOOL)isOn {
    
}

- (NSArray<id<RCSReverbItemProtocol>> *)reverbItemsInTunerViewController:(RCSKTVTunerViewController *)tunerVC {
    return self.reverbData;
}

#pragma mark - RCSKTVMusicLibraryDelegate
/// 已点列表数据变化
- (void)selectedMusicListUpdated:(NSDictionary *)dataDic {
    NSLog(@"==> songQueue:%@",dataDic[@"songQueue"]);
    NSArray *musicList = dataDic[@"songQueue"];
    NSString *firstId = musicList.lastObject[@"musicId"];
    if ([self.currentPlayId isEqualToString:firstId]) {
        return ;
    }
    self.currentPlayId = firstId;
    [self testHifiveKrcLyricWithMusicId:firstId];
}

/// 申请置顶歌曲
- (void)applyForTopMusic:(id<RCSKTVRoomMusicProtocol>)model {
    
}

/// 点击控麦按钮
- (void)controlMic {
    
}

/// 删除歌成功
- (void)deleteMusic {
    
}

/// 置顶歌成功
- (void)topMusic {
    
}

/// 点歌成功
- (void)selectedMusic {
    
}

#pragma mark - lazy load
- (RCSKTVScreen *)screen {
    if (!_screen) {
        _screen = [RCSKTVScreen new];
        _screen.image = [UIImage imageNamed:@"ktv_screen_bg"];
        _screen.delegate = self;
    }
    return _screen;
}

- (RCSCountdown *)readyCountdown {
    if (!_readyCountdown) {
        _readyCountdown = [RCSCountdown new];
    }
    return _readyCountdown;
}

- (RCSCountdown *)waitCountdown {
    if (!_waitCountdown) {
        _waitCountdown = [RCSCountdown new];
    }
    return _waitCountdown;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation:)];
        self.displayLink.preferredFramesPerSecond = 1;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (RCSKTVTunerViewController *)tuner {
    if (!_tuner) {
        _tuner = [[RCSKTVTunerViewController alloc] initWithConfig:self.tunerConfig];
        _tuner.delegate = self;
        _tuner.dataSource = self;
    }
    return _tuner;
}

- (NSArray<id<RCSReverbItemProtocol>> *)reverbData {
    if (!_reverbData) {
        NSArray *titles =  @[@"原生",
                             @"KTV",
                             @"演唱会",
                             @"饱满",
                             @"低沉",
                             @"高亢",
                             @"假声",
                             @"绿巨人",
                             @"男孩",
                             @"女孩",
                             @"老男人",
                             @"男青年",
                             @"女青年"];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:13];
        for (NSString *title in titles) {
            RCSReverbItem *item = [RCSReverbItem new];
            item.title = title;
            [items addObject:item];
        }
        _reverbData = items.copy;
    }
    return _reverbData;
}

- (UIButton *)musicListButton {
    if (!_musicListButton) {
        _musicListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _musicListButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _musicListButton.backgroundColor = [UIColor redColor];
        [_musicListButton setTitle:@"弹出歌单" forState:UIControlStateNormal];
        [_musicListButton addTarget:self action:@selector(presentMusicLibraryViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _musicListButton;
}

//- (RCSKTVMusicLibrary *)musicLibrary {
//    if (!_musicLibrary) {
//        RCSKTVMusicLibraryConfig *config = [RCSKTVMusicLibraryConfig new];
//        config.hadCreateRoom = NO;
//        config.roomId = @"123456"; /// whatever
//        config.currentUserId = <#用户登录后返回的userId#> ;
//        config.currentUserName = @""; /// 用户登录后返回的username
//        config.currentUserPortrait = @"https://img0.baidu.com/it/u=1694074520,2517635995&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500";
//        config.netBaseUrl = @"https://rcrtc-api.rongcloud.net/";
//        config.netBusinessToken = <#网络请求 header  businessToken#>;
//        config.netAuth = <#网络请求 header 用户登录后返回的 auth#>;
//        _musicLibrary = [[RCSKTVMusicLibrary alloc] initWithConfig:config];
//        _musicLibrary.delegate = self;
//    }
//    return _musicLibrary;
//}

@end
