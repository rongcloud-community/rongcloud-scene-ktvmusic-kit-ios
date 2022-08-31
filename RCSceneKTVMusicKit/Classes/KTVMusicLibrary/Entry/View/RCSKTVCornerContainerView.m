//
//  RCSKTVCornerContainerView.m
//  Pods
//
//  Created by xuefeng on 2022/7/6.
//

#import "RCSKTVCornerContainerView.h"

@interface RCSKTVCornerContainerView()
@property (nonatomic, assign) UIRectCorner corner;
@property (nonatomic, assign) CGFloat radios;
@end

@implementation RCSKTVCornerContainerView

- (instancetype)initWithRectCorner:(UIRectCorner)corner radios:(CGFloat)radios {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.165];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        [self addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.corner = corner;
        self.radios = radios;
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.layer.mask) {
        UIBezierPath *maskPath = [UIBezierPath
                bezierPathWithRoundedRect:self.bounds
                        byRoundingCorners:self.corner
                              cornerRadii:CGSizeMake(self.radios, self.radios)
        ];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}
@end
