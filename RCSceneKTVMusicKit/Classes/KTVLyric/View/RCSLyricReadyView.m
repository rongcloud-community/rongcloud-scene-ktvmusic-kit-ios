//
//  RCSLyricReadyView.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricReadyView.h"

@interface RCSLyricReadyView ()

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation RCSLyricReadyView
- (instancetype)init {
    if (self = [super init]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset(0);
        make.height.mas_equalTo(8);
    }];
    
    for (int i = 0; i<4; i++) {
        UIView *hintView = [self hintIcon];
        [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(5);
        }];
        [self.stackView addArrangedSubview:hintView];
    }
}

- (UIView *)hintIcon {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 2.5;
    return view;
}

- (void)show {
    self.hidden = NO;
    [[RCSCountdown new] startCountdownWithTime:5 countdownCallBack:^(int timeStr) {
        int index = 5 - timeStr;
        int count = (int)self.stackView.arrangedSubviews.count;
        if (index >= 0 && index < count) {
            UIView *view = self.stackView.arrangedSubviews[index];
            view.hidden = YES;
        }
    } countdownFinishCallBack:^{
        self.hidden = YES;
    }];
}

#pragma mark - lazy load
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualCentering;
        _stackView.spacing = 8;
    }
    return _stackView;
}


@end
