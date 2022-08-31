//
//  RCSTunerReverbCVCell.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import "RCSTunerReverbCVCell.h"

@interface RCSTunerReverbCVCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation RCSTunerReverbCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.bgView.backgroundColor = selected ? RCSKTVMusicMainColor : [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.2];
}

- (void)buildLayout {
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
}

#pragma mark - public method
- (void)updateUIWithReverb:(NSString *)reverb {
    self.titleLabel.text = reverb;
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.2];
        _bgView.layer.cornerRadius = self.height / 2.0;
    }
    return _bgView;
}

@end
