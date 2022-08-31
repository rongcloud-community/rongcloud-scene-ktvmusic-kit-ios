//
//  RCSScreenToolbar.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSScreenToolbar.h"

@interface RCSScreenToolbar ()

@property (nonatomic, strong) UIButton *tunerBtn;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *originBtn;

@end

@implementation RCSScreenToolbar

- (instancetype)init {
    if (self = [super init]) {
        self.isLead = NO;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.tunerBtn];
    [self.tunerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.offset(0);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.trailing.offset(-6);
    }];
    [self.stackView addArrangedSubview:self.skipBtn];
    [self.stackView addArrangedSubview:self.playBtn];
    [self.stackView addArrangedSubview:self.originBtn];
}

- (void)setIsLead:(BOOL)isLead {
    _isLead = isLead;
    self.stackView.hidden = !isLead;
}

- (void)setOrigin:(BOOL)origin {
    _origin = origin;
    self.originBtn.selected = origin;
}

- (void)setPlay:(BOOL)play {
    _play = play;
    self.playBtn.selected = play;
}

#pragma mark - btn acitons
- (void)showTuner {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTuner)]) {
        [self.delegate showTuner];
    }
}

- (void)skipIt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(skipTheSong)]) {
        [self.delegate skipTheSong];
    }
}

- (void)playIt:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playTheSong:)]) {
        [self.delegate playTheSong:btn.isSelected];
    }
}

- (void)originIt:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(turnToOriginalSong:)]) {
        [self.delegate turnToOriginalSong:btn.isSelected];
    }
}

#pragma mark - lazy load
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualCentering;
        _stackView.spacing = 12;
    }
    return _stackView;
}

- (UIButton *)tunerBtn {
    if (!_tunerBtn) {
        _tunerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tunerBtn.backgroundColor = [UIColor clearColor];
        [_tunerBtn setImage:RCSKTVMusicImageNamed(@"toolbar_showtuner")
                  forState:UIControlStateNormal];
        [_tunerBtn addTarget:self action:@selector(showTuner) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tunerBtn;
}

- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [self configSubBtn];
        [_skipBtn setImage:RCSKTVMusicImageNamed(@"toolbar_skip")
                  forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipIt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [self configSubBtn];
        [_playBtn setImage:RCSKTVMusicImageNamed(@"toolbar_suspend_normal")
                  forState:UIControlStateNormal];
        [_playBtn setImage:RCSKTVMusicImageNamed(@"toolbar_suspend_selected")
                  forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playIt:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)originBtn {
    if (!_originBtn) {
        _originBtn = [self configSubBtn];
        [_originBtn setImage:RCSKTVMusicImageNamed(@"toolbar_origin_normal")
                  forState:UIControlStateNormal];
        [_originBtn setImage:RCSKTVMusicImageNamed(@"toolbar_origin_selected")
                  forState:UIControlStateSelected];
        [_originBtn addTarget:self action:@selector(originIt:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originBtn;
}

- (UIButton *)configSubBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(16);
    }];
    return btn;
}

@end
