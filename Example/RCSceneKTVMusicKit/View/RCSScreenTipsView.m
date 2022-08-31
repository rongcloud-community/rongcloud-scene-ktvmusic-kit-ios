//
//  RCSScreenTipsView.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSScreenTipsView.h"
#import <Masonry/Masonry.h>
#import <RCSceneBaseKit/RCSBaseKit.h>

@interface RCSScreenTipsView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UIStackView *cdStackView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *soloBtn;
@property (nonatomic, strong) UIButton *inviteBtn;
@property (nonatomic, strong) UIButton *joinBtn;

@property (nonatomic, assign) int readyCountdownTime;
@property (nonatomic, assign) int waitingCountdownTime;

@end

@implementation RCSScreenTipsView

- (instancetype)init {
    if (self = [super init]) {
        [self buildLayout];
        self.readyCountdownTime = 5;
        self.waitingCountdownTime = 30;
        self.style = RCSScreenTipsViewStyleWelcome;
    }
    return self;
}

- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(58);
    }];
    
    [self addSubview:self.cdStackView];
    [self.cdStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
    }];
    
    [self.cdStackView addArrangedSubview:self.countdownLabel];
    [self.cdStackView addArrangedSubview:self.subTitleLabel];
    
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(self.cdStackView.mas_bottom).offset(20);
    }];
    
    [self.stackView addArrangedSubview:self.soloBtn];
    [self.stackView addArrangedSubview:self.joinBtn];
    [self.stackView addArrangedSubview:self.inviteBtn];
}

#pragma mark - public method
- (void)setStyle:(RCSScreenTipsViewStyle)style {
    switch (style) {
        case RCSScreenTipsViewStyleSingReady:
            self.stackView.hidden = YES;
            self.countdownLabel.hidden = NO;
            self.titleLabel.text = [NSString stringWithFormat:@"《%@》",self.songTitle];
            self.subTitleLabel.text = @"秒后即将开始";
            self.countdownLabel.text = [NSString stringWithFormat:@"%d",self.readyCountdownTime];
            break;
            
        case RCSScreenTipsViewStyleControlReady:
            self.stackView.hidden = YES;
            self.countdownLabel.hidden = NO;
            self.titleLabel.text = @"房主控麦";
            self.subTitleLabel.text = @"秒后即将开始";
            self.countdownLabel.text = [NSString stringWithFormat:@"%d",self.readyCountdownTime];
            break;
            
        case RCSScreenTipsViewStyleControling:
            self.stackView.hidden = YES;
            self.countdownLabel.hidden = YES;
            self.titleLabel.text = @"房主控麦";
            self.subTitleLabel.text = @"控麦中";
            break;
            
        case RCSScreenTipsViewStyleSingerWait:
            self.stackView.hidden = NO;
            self.countdownLabel.hidden = NO;
            self.soloBtn.hidden = NO;
            self.inviteBtn.hidden = NO;
            self.joinBtn.hidden = YES;
            self.titleLabel.text = [NSString stringWithFormat:@"《%@》",self.songTitle];
            self.subTitleLabel.text = @"秒后即将开始";
            self.countdownLabel.text = [NSString stringWithFormat:@"%d",self.waitingCountdownTime];
            break;
        case RCSScreenTipsViewStyleAudienceWait:
            self.stackView.hidden = NO;
            self.countdownLabel.hidden = NO;
            self.soloBtn.hidden = YES;
            self.inviteBtn.hidden = YES;
            self.joinBtn.hidden = NO;
            self.titleLabel.text = [NSString stringWithFormat:@"《%@》",self.songTitle];
            self.subTitleLabel.text = @"秒后即将开始";
            self.countdownLabel.text = [NSString stringWithFormat:@"%d",self.waitingCountdownTime];
            break;
            
        default:
            self.titleLabel.text = @"欢迎体验融云在线KTV";
            self.subTitleLabel.text = @"开始上麦点歌吧";
            self.stackView.hidden = YES;
            self.countdownLabel.hidden = YES;
            break;
    }
}

- (void)setSongTitle:(NSString *)songTitle {
    _songTitle = songTitle;
    self.titleLabel.text = [NSString stringWithFormat:@"《%@》",songTitle];
}

- (void)updateReadyCountdownTime:(int)sec {
    self.readyCountdownTime = sec;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d",self.readyCountdownTime];
}

- (void)updateWaitingCountdownTime:(int)sec {
    self.waitingCountdownTime = sec;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d",self.waitingCountdownTime];
}

#pragma mark - btn actions
- (void)soloBtnClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(solo)]) {
        [self.delegate solo];
    }
}

- (void)inviteBtnClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(invite)]) {
        [self.delegate invite];
    }
}

- (void)joinBtnClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(join)]) {
        [self.delegate join];
    }
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
    return _subTitleLabel;
}

- (UILabel *)countdownLabel {
    if (!_countdownLabel) {
        _countdownLabel = [UILabel new];
        _countdownLabel.text = @"5";
        _countdownLabel.textAlignment = NSTextAlignmentRight;
        _countdownLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _countdownLabel.textColor = [UIColor whiteColor];
        [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(26);
        }];
    }
    return _countdownLabel;
}

- (UIStackView *)cdStackView {
    if (!_cdStackView) {
        _cdStackView = [UIStackView new];
        _cdStackView.alignment = UIStackViewAlignmentCenter;
        _cdStackView.axis = UILayoutConstraintAxisHorizontal;
        _cdStackView.distribution = UIStackViewDistributionEqualCentering;
        _cdStackView.spacing = 2;
    }
    return _cdStackView;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualCentering;
        _stackView.spacing = 42;
    }
    return _stackView;
}

- (UIButton *)soloBtn {
    if (!_soloBtn) {
        _soloBtn = [self configSubBtn];
        [_soloBtn setTitle:@"不等了，独唱" forState:UIControlStateNormal];
        [_soloBtn addTarget:self action:@selector(soloBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soloBtn;
}

- (UIButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [self configSubBtn];
        [_inviteBtn setTitle:@"邀请合唱" forState:UIControlStateNormal];
        [_inviteBtn addTarget:self action:@selector(inviteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [self configSubBtn];
        [_joinBtn setTitle:@"加入合唱" forState:UIControlStateNormal];
        [_joinBtn addTarget:self action:@selector(joinBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBtn;
}

- (UIButton *)configSubBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor rcs_colorWithHex:0xCDCDCD alpha:0.3];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    btn.layer.cornerRadius = 16.0;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(114);
        make.height.mas_equalTo(32);
    }];
    return btn;
}

@end
