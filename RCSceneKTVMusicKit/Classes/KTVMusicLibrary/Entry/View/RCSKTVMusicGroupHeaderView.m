//
//  RCSKTVMusicGroupHeaderView.m
//  RCSceneKTVMusicKit
//
//  Created by xuefeng on 2022/7/7.
//

#import "RCSKTVMusicGroupHeaderView.h"

@interface RCSKTVMusicGroupHeaderView()
@property (nonatomic, strong) UISegmentedControl   *segmentControl;
@end

@implementation RCSKTVMusicGroupHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setType:(RCSKTVMusicGroupHeaderType)type {
    _type = type;
    self.segmentControl.selectedSegmentIndex = (int)type;
}

- (void)updateTitle:(NSString *)title withType:(RCSKTVMusicGroupHeaderType)type {
    [self.segmentControl setTitle:title forSegmentAtIndex:(int)type];
}

#pragma mark - PRIVATE METHOD

- (void)segmentControlClick {
    self.type = self.segmentControl.selectedSegmentIndex;
    if (self.closure) {
        self.closure(self.segmentControl.selectedSegmentIndex);
    }
}

#pragma mark - SETUPSUBVIEWS

- (void)setupSubviews {
    [self addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.1];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.bottom.offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - GETTER

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"点歌",@"已点(0)"]];
        [_segmentControl setTintColor:[UIColor clearColor]];
        [_segmentControl setDividerImage:[UIImage rcs_imageWithColor:[UIColor clearColor]]
                     forLeftSegmentState:UIControlStateNormal
                       rightSegmentState:UIControlStateNormal
                              barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:[UIImage rcs_imageWithColor:[UIColor clearColor]]
                                   forState:UIControlStateNormal
                                 barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:[UIImage rcs_imageWithColor:[UIColor clearColor]]
                                   forState:UIControlStateSelected
                                 barMetrics:UIBarMetricsDefault];
        [_segmentControl setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor rcs_colorWithHex:0xEF499A],
                                                              NSFontAttributeName: [UIFont systemFontOfSize:17]}
                                       forState:UIControlStateSelected];
        [_segmentControl setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor],
                                                              NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                       forState:UIControlStateNormal];
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(segmentControlClick) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
@end
