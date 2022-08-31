//
//  RCSKTVScreen.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/17.
//

#import "RCSKTVScreen.h"
#import "RCSLyricView.h"
#import "RCSScreenToolbar.h"

@interface RCSKTVScreen ()<RCSScreenToolbarDelegate>

@property (nonatomic, strong) RCSLyricView *lyricView;
@property (nonatomic, strong) RCSScreenToolbar *toolbar;

@end

@implementation RCSKTVScreen
- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.lyricView];
    [self.lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.inset(0);
        make.top.inset(58);
    }];
    
    [self addSubview:self.toolbar];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.inset(12);
        make.bottom.offset(-10);
        make.height.offset(20);
    }];
    
}

#pragma mark - public method
/// 切歌
- (void)resetScreenWithLyricURL:(nullable NSURL *)lyricURL role:(RCSKTVScreenRole)role {
    if (lyricURL.path.length != 0) {
        [self.lyricView configCurrentSongWithURL:lyricURL];
    }
    self.lyricView.hidden = NO;
    self.toolbar.hidden = (role == RCSKTVScreenRoleAudience);
    self.toolbar.play = YES;
    self.toolbar.isLead = (role == RCSKTVScreenRoleLeadSinger);
}

- (void)setOrigin:(BOOL)origin {
    self.toolbar.origin = origin;
}

- (void)setPlay:(BOOL)play {
    self.toolbar.play = play;
}

/// 更新歌曲进度，用于歌词滚动
- (void)updateScreenWithCurrentTime:(CGFloat)currentTime {
    [self.lyricView updateCurrentPlayingTime:currentTime];
}

#pragma mark - RCSScreenToolbarDelegate
/// 展示调音面板 --- 弹出调音面板
- (void)showTuner {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTuner)]) {
        [self.delegate showTuner];
    }
}

/// 切歌
- (void)skipTheSong {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextSong)]) {
        [self.delegate nextSong];
    }
}

/// 暂停/续播 歌曲
- (void)playTheSong:(BOOL)play {
    if (self.delegate && [self.delegate respondsToSelector:@selector(play:)]) {
        [self.delegate play:play];
        [self.lyricView stopAnimation:!play];
    }
}

/// 切换原/伴唱
/// @param origin  yes 原唱，no 伴唱
- (void)turnToOriginalSong:(BOOL)origin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(turnToOriginSong:)]) {
        [self.delegate turnToOriginSong:origin];
    }
}

#pragma mark - lazy load
- (RCSLyricView *)lyricView {
    if (!_lyricView) {
        _lyricView = [RCSLyricView new];
        _lyricView.hidden = YES;
    }
    return _lyricView;
}

- (RCSScreenToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [RCSScreenToolbar new];
        _toolbar.delegate = self;
        _toolbar.hidden = YES;
    }
    return _toolbar;
}

@end
