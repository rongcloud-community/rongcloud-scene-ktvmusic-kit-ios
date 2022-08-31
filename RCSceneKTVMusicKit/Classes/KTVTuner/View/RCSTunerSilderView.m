//
//  RCSTunerSilderView.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import "RCSTunerSilderView.h"

@interface RCSTunerSilderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RCSTunerSlider *slider;

@end

@implementation RCSTunerSilderView

- (instancetype)initWithTitle:(NSString *)title thumbSize:(CGSize)size {
    if (self = [super init]) {
        self.titleLabel.text = title;
        self.slider.thumbSize = size;
        [self.slider setThumbImage:[self imageResize:RCSKTVMusicImageNamed(@"tuner_silder_thumb") andResizeTo:size]
                      forState:UIControlStateNormal];
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
    
    [self addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel.mas_trailing).offset(16);
        make.trailing.offset(-16);
        make.centerY.offset(0);
    }];
}

- (void)sliderAction:(UISlider *)slider {
    !self.valueChangedBlock ?: self.valueChangedBlock(slider.value);
}

- (void)setValue:(float)value {
    _value = value;
    self.slider.value = value;
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

- (UISlider *)slider {
    if (!_slider) {
        _slider = [RCSTunerSlider new];
        _slider.maximumTrackTintColor = [UIColor rcs_colorWithHex:0xDAD8E6];
        _slider.minimumTrackTintColor = RCSKTVMusicMainColor;
        [_slider addTarget:self
                    action:@selector(sliderAction:)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation RCSTunerSlider

/// 设置thumb（滑块）尺寸
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    
    CGFloat WH = self.thumbSize.width;
    CGFloat margin = WH *.5f;
    /// 滑块的滑动区域宽度
    CGFloat maxWidth = CGRectGetWidth(rect) + 2 * margin;
    /// 每次偏移量
    CGFloat offset = (maxWidth - WH)/(self.maximumValue - self.minimumValue);
    
    CGFloat H = self.thumbSize.height;
    CGFloat Y = (bounds.size.height - H + 4) *.5f;
    CGFloat W = self.thumbSize.width;
    CGFloat X = CGRectGetMinX(rect) - margin + offset *(value-self.minimumValue);
    return CGRectMake(X, Y, W, H);
}

@end

