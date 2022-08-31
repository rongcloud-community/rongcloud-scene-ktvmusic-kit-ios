//
// Created by xuefeng on 2022/7/8.
//

#import "RCSKTVMusicLibraryViewController.h"
#import "RCSKTVMusicGroupListViewController.h"
#import "RCSKTVCornerContainerView.h"
#import "RCSKTVMusicGroupHeaderView.h"
#import "RCSKTVMusicSelectedViewController.h"
#import "RCSKTVMusicListSelectedDelegate.h"

static NSInteger kGroupChildViewControllerViewTag    = 1000;
static NSInteger kSelectedChildViewControllerViewTag = 1001;

@interface RCSKTVMusicLibraryViewController()<RCSKTVMusicListSelectedDelegate, RCSKTVMusicSelectedViewControllerDelegate>

@property  (nonatomic, strong) RCSKTVCornerContainerView            *containerView;
@property  (nonatomic, strong) RCSKTVMusicGroupHeaderView           *groupHeaderView;
@property  (nonatomic, strong) RCSKTVMusicGroupListViewController   *musicGroupListViewController;
@property  (nonatomic, strong) RCSKTVMusicSelectedViewController    *musicSelectedViewController;
@property  (nonatomic, strong) RCSKTVMusicLibraryConfig             *config;

@end

@implementation RCSKTVMusicLibraryViewController

- (instancetype)initWithConfig:(RCSKTVMusicLibraryConfig *)config {
    if (self = [super init]) {
        self.config = config;
        [RCSKTVMusicLibraryConfig configWithBaseUrl:config.netBaseUrl
                                      businessToken:config.netBusinessToken
                                               auth:config.netAuth];
        [self addMusicGroupListViewController];
        [self setupSubviews];
    }
    return self;
}

- (void)setSeletectedIndex:(int)seletectedIndex {
    _seletectedIndex = seletectedIndex;
    self.groupHeaderView.type = seletectedIndex;
    if (self.groupHeaderView.type == RCSKTVMusicGroupHeaderTypeMusicList) {
        [self toggleViewController:self.musicGroupListViewController];
    } else{
        [self toggleViewController:self.musicSelectedViewController];
    }
}

- (void)setSolo:(BOOL)solo {
    _solo = solo;
    self.musicSelectedViewController.solo = solo;
}

- (void)setPlayingId:(NSString *)playingId {
    _playingId = playingId;
    self.musicSelectedViewController.playingId = playingId;
}

#pragma mark - PRIVATE METHOD

- (void)addMusicGroupListViewController {
    [self addChildViewController:self.musicGroupListViewController];
    [self addChildViewController:self.musicSelectedViewController];
}

- (void)toggleViewController:(UIViewController *)viewController {
    for (UIView *view in self.containerView.subviews) {
        if (view.tag == kGroupChildViewControllerViewTag ||
            view.tag == kSelectedChildViewControllerViewTag) {
            [view removeFromSuperview];
        }
    }
    [self.containerView addSubview:viewController.view];
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupHeaderView.mas_bottom);
        make.trailing.leading.bottom.equalTo(self.containerView);
    }];
}

#pragma mark - SETUPSUBVIEWS

- (void)setupSubviews {
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(650);
        make.bottom.equalTo(self.view);
    }];
    
    UIControl *control = [UIControl new];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.offset(0);
        make.bottom.mas_equalTo(self.containerView.mas_top);
    }];

    [self.containerView addSubview:self.groupHeaderView];
    [self.groupHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.containerView);
        make.height.mas_equalTo(64);
    }];

    [self.containerView addSubview:self.musicGroupListViewController.view];
    [self.musicGroupListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupHeaderView.mas_bottom);
        make.trailing.leading.bottom.equalTo(self.containerView);
    }];
}

- (void)controlAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - RCSKTVMusicListSelectedDelegate
- (void)musicListUpdated:(NSDictionary *)musicData musicCount:(int)count {
    NSString *title = [NSString stringWithFormat:@"已点(%d)", count];
    [self.groupHeaderView updateTitle:title withType:RCSKTVMusicGroupHeaderTypeSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedMusicListUpdated:)]) {
        [self.delegate selectedMusicListUpdated:musicData];
    }
}

- (void)applyForTopMusic:(id<RCSKTVRoomMusicProtocol>)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyForTopMusic:)]) {
        [self.delegate applyForTopMusic:model];
    }
}

- (void)controlMic {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlMic)]) {
        [self.delegate controlMic];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteMusic:(id<RCSKTVRoomMusicProtocol>)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMusic:)]) {
        [self.delegate deleteMusic:model];
    }
}

- (void)topMusic:(id<RCSKTVRoomMusicProtocol>)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topMusic:)]) {
        [self.delegate topMusic:model];
    }
}

#pragma mark - RCSKTVMusicListSelectedDelegate
- (void)selectedSong:(id<RCSKTVSongProtocol>)song {
    [_musicSelectedViewController selectedSongWithArtistName:song.artistName
                                                     musicId:song.musicId
                                                   musicName:song.musicName
                                             completionBlock:^(BOOL success) {
        if (!success) {
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"点歌成功"];
        /// 点歌回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedMusic)]) {
            [self.delegate selectedMusic];
        }
        /// 更新歌曲列表
        [self.musicSelectedViewController fetchMusicListCompletionBlock:nil];
    }];
}

#pragma mark - GETTER
- (RCSKTVCornerContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[RCSKTVCornerContainerView alloc]
                          initWithRectCorner:UIRectCornerTopRight|UIRectCornerTopLeft radios:20];
    }
    return  _containerView;
}

- (RCSKTVMusicGroupHeaderView *)groupHeaderView {
    if (!_groupHeaderView) {
        _groupHeaderView = [[RCSKTVMusicGroupHeaderView alloc] init];
        WeakSelf(self)
        [_groupHeaderView setClosure:^(RCSKTVMusicGroupHeaderType type) {
            if (type == RCSKTVMusicGroupHeaderTypeMusicList) {
                [weakSelf toggleViewController:weakSelf.musicGroupListViewController];
            } else{
                [weakSelf toggleViewController:weakSelf.musicSelectedViewController];
            }
        }];
    }
    return _groupHeaderView;
}

- (RCSKTVMusicSelectedViewController *)musicSelectedViewController {
    if (!_musicSelectedViewController) {
        _musicSelectedViewController = [[RCSKTVMusicSelectedViewController alloc]
                                        initWithRoomId:self.config.roomId
                                        hadCreateRoom:self.config.hadCreateRoom
                                        currentUserId:self.config.currentUserId
                                        currentUserName:self.config.currentUserName
                                        currentUserPortrait:self.config.currentUserPortrait];
        _musicSelectedViewController.delegate = self;
        _musicSelectedViewController.view.tag = kSelectedChildViewControllerViewTag;
    }
    return _musicSelectedViewController;
}

- (RCSKTVMusicGroupListViewController *)musicGroupListViewController {
    if (!_musicGroupListViewController) {
        _musicGroupListViewController = [RCSKTVMusicGroupListViewController new];
        _musicGroupListViewController.view.tag = kGroupChildViewControllerViewTag;
        _musicGroupListViewController.delegate = self;
    }
    return _musicGroupListViewController;
}

@end
