//
//  RCSTunerStepperView.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/30.
//

#import "RCSTunerStepperView.h"

@interface RCSTunerStepperView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RCSStepperView *stepperView;

@end

@implementation RCSTunerStepperView
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
        make.width.mas_equalTo(60);
        make.leading.offset(16);
        make.centerY.offset(0);
        make.top.bottom.offset(0).priorityLow();
    }];
    
    [self addSubview:self.stepperView];
    [self.stepperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-16);
        make.centerY.offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(28);
    }];
}

- (void)setValue:(int)value {
    _value = value;
    self.stepperView.value = value;
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

- (RCSStepperView *)stepperView {
    if (!_stepperView) {
        _stepperView = [RCSStepperView new];
        _stepperView.layer.cornerRadius = 14;
        _stepperView.minimumValue = -12;
        _stepperView.maximumValue = 12;
        WeakSelf(self);
        _stepperView.valueChangedBlock = ^(int value) {
            StrongSelf(weakSelf);
            !strongSelf.valueChangedBlock ?: strongSelf.valueChangedBlock(value);
        };
    }
    return _stepperView;
}

@end

@interface RCSStepperView ()

@property (nonatomic, strong) UIButton *reduceBtn;
@property (nonatomic, strong) UILabel *countlabel;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation RCSStepperView
- (instancetype)init {
    if (self = [super init]) {
        self.value = 0;
        self.stepValue = 1;
        self.minimumValue = 0;
        self.maximumValue = 100;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    self.backgroundColor = [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.2];
    
    [self addSubview:self.reduceBtn];
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.leading.offset(2);
        make.width.height.offset(22);
    }];
    
    [self addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.trailing.offset(-2);
        make.width.height.offset(22);
    }];
    
    [self addSubview:self.countlabel];
    [self.countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
}

- (void)addAction {
    if (self.value >= self.maximumValue) {
        return;
    }
    self.value += self.stepValue;
}

- (void)reduceAction {
    if (self.value <= self.minimumValue) {
        return;
    }
    self.value -= self.stepValue;
}

- (void)setValue:(int)value {
    _value = value;
    _countlabel.text = [NSString stringWithFormat:@"%d", _value];
    !self.valueChangedBlock ?: self.valueChangedBlock(value);
}

#pragma mark - lazy load
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor = RCSKTVMusicMainColor;
        _addBtn.layer.cornerRadius = 11;
        _addBtn.tag = 1000;
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:28];
        _addBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UILabel *)countlabel {
    if (!_countlabel) {
        _countlabel = [UILabel new];
        _countlabel.text = @"0";
        _countlabel.textColor = [UIColor whiteColor];
        _countlabel.font = [UIFont systemFontOfSize:14];
    }
    return _countlabel;
}

- (UIButton *)reduceBtn {
    if (!_reduceBtn) {
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.backgroundColor = RCSKTVMusicMainColor;
        _reduceBtn.layer.cornerRadius = 11;
        _reduceBtn.tag = 1111;
        _reduceBtn.titleLabel.font = [UIFont systemFontOfSize:28];
        _reduceBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        [_reduceBtn setTitle:@"-" forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

@end
