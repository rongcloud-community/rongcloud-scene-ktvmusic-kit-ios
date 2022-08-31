//
//  RCSTunerSwitchView.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import "RCSTunerSwitchView.h"

@interface RCSTunerSwitchView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *switchControl;

@end


@implementation RCSTunerSwitchView

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.titleLabel.text = title;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(16);
        make.centerY.offset(0);
        make.top.bottom.offset(0).priorityLow();
    }];
    
    [self addSubview:self.switchControl];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-16);
        make.centerY.offset(0);
    }];
}

- (void)switchAction:(UISwitch *)switchControl {
    !self.valueChangedBlock ?: self.valueChangedBlock(switchControl.isOn);
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    self.switchControl.on = isOn;
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UISwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [UISwitch new];
        _switchControl.backgroundColor = [UIColor clearColor];
        _switchControl.layer.borderColor = [UIColor rcs_colorWithHex:0xE5E5EA].CGColor;
        _switchControl.layer.borderWidth = 2.0;
        _switchControl.layer.cornerRadius = 16;
        [_switchControl addTarget:self
                           action:@selector(switchAction:)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

@end
