//
//  RCSKTVTunerViewController.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import "RCSKTVTunerViewController.h"
#import "RCSTunerReverbCVCell.h"
#import "RCSTunerSilderView.h"
#import "RCSTunerSwitchView.h"
#import "RCSTunerStepperView.h"

@interface RCSKTVTunerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *reverbView;
@property (nonatomic, strong) UILabel *reverbLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RCSTunerSilderView *accompSider;
@property (nonatomic, strong) RCSTunerSilderView *vocalSider;
@property (nonatomic, strong) RCSTunerSwitchView *earReturnSwitch;
@property (nonatomic, strong) RCSTunerStepperView *toneStepper;
@property (nonatomic, copy) NSArray<id<RCSReverbItemProtocol>> *reverbs;

@end

@implementation RCSKTVTunerViewController

- (instancetype)initWithConfig:(RCSKTVTunerConfig *)config {
    if (self = [super init]) {
        self.config = config ?: [RCSKTVTunerConfig new];
    }
    return self;
}

- (void)setConfig:(RCSKTVTunerConfig *)config {
    _config = config;
    self.vocalSider.value = self.config.vocalVolume;
    self.accompSider.value = self.config.accompVolume;
    self.earReturnSwitch.isOn = self.config.isEarReturn;
    self.accompSider.hidden = !self.config.isLead;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(reverbItemsInTunerViewController:)]) {
        self.reverbs = [self.dataSource reverbItemsInTunerViewController:self];
    } else {
        self.reverbs = @[];
    }
    [self.collectionView reloadData];
    
    self.reverbView.hidden = (self.reverbs.count <= 0);
    if (self.config.reverbSelectedIndex >= self.reverbs.count) {
        return;
    }
    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:self.config.reverbSelectedIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPathForFirstRow
                                      animated:NO
                                scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPathForFirstRow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath
        bezierPathWithRoundedRect:_containerView.bounds
        byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
        cornerRadii:CGSizeMake(20, 20)
    ];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    _containerView.layer.mask = maskLayer;
}

- (void)buildLayout {
    CGFloat margin = 16;
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.bottom.offset(0);
    }];
    
    UIControl *control = [UIControl new];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.offset(0);
        make.bottom.mas_equalTo(self.containerView.mas_top);
    }];
    
    [self.containerView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.top.inset(24);
        make.bottom.inset(32);
    }];
    
    [self.reverbView addSubview:self.reverbLabel];
    [self.reverbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(margin);
    }];
    
    [self.reverbView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.reverbLabel);
        make.top.mas_equalTo(self.reverbLabel.mas_bottom).offset(margin);
        make.trailing.offset(0);
        make.height.mas_equalTo(56);
        make.bottom.offset(0);
    }];
    
    [self.stackView addArrangedSubview:self.reverbView];
    [self.stackView addArrangedSubview:self.vocalSider];
    [self.stackView addArrangedSubview:self.accompSider];
    [self.stackView addArrangedSubview:self.earReturnSwitch];
}

- (void)controlAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - public method
- (void)showIn:(nonnull UIViewController *)vc {
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [vc presentViewController:self animated:YES completion:nil];
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reverbChanged:)]) {
        [self.delegate reverbChanged:indexPath.row];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.reverbs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSTunerReverbCVCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RCSTunerReverbCVCell.class)
                                  forIndexPath:indexPath];
    id<RCSReverbItemProtocol> item = self.reverbs[indexPath.row];
    [cell updateUIWithReverb:[item title]];
    return cell;
}

#pragma mark - lazy load
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.165];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effe = [[UIVisualEffectView alloc]initWithEffect:blur];
        [_containerView addSubview:effe];
        [effe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _containerView;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        _stackView.spacing = 32;
    }
    return _stackView;
}

- (UIView *)reverbView {
    if (!_reverbView) {
        _reverbView = [UIView new];
        _reverbView.backgroundColor = [UIColor clearColor];
    }
    return _reverbView;
}

- (UILabel *)reverbLabel {
    if (!_reverbLabel) {
        _reverbLabel = [UILabel new];
        _reverbLabel.text = @"混响音效";
        _reverbLabel.textColor = [UIColor whiteColor];
        _reverbLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _reverbLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 24;
        layout.minimumInteritemSpacing = 24;
        layout.itemSize = CGSizeMake(56, 56);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 16);
        [_collectionView registerClass:RCSTunerReverbCVCell.class
            forCellWithReuseIdentifier:NSStringFromClass(RCSTunerReverbCVCell.class)];
    }
    return _collectionView;
}

- (RCSTunerSilderView *)accompSider {
    if (!_accompSider) {
        _accompSider = [[RCSTunerSilderView alloc] initWithTitle:@"伴奏音量" thumbSize:CGSizeMake(24, 24)];
        WeakSelf(self);
        _accompSider.valueChangedBlock = ^(float value) {
            StrongSelf(weakSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(accompVolumeChanged:)]) {
                [strongSelf.delegate accompVolumeChanged:value];
            }
        };
    }
    return _accompSider;
}

- (RCSTunerSilderView *)vocalSider {
    if (!_vocalSider) {
        _vocalSider = [[RCSTunerSilderView alloc] initWithTitle:@"人声音量" thumbSize:CGSizeMake(40, 40)];
        WeakSelf(self);
        _vocalSider.valueChangedBlock = ^(float value) {
            StrongSelf(weakSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(vocalVolumeChanged:)]) {
                [strongSelf.delegate vocalVolumeChanged:value];
            }
        };
    }
    return _vocalSider;
}

- (RCSTunerStepperView *)toneStepper {
    if (!_toneStepper) {
        _toneStepper = [[RCSTunerStepperView alloc] initWithTitle:@"升降调"];
        WeakSelf(self);
        _toneStepper.valueChangedBlock = ^(int value) {
            StrongSelf(weakSelf);
            if (strongSelf.delegate && [strongSelf.delegate
                                        respondsToSelector:@selector(toneStepperChanged:)]) {
                [strongSelf.delegate toneStepperChanged:value];
            }
        };
    }
    return _toneStepper;
}

- (RCSTunerSwitchView *)earReturnSwitch {
    if (!_earReturnSwitch) {
        _earReturnSwitch = [[RCSTunerSwitchView alloc] initWithTitle:@"耳返"];
        WeakSelf(self);
        _earReturnSwitch.valueChangedBlock = ^(BOOL isOn) {
            StrongSelf(weakSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(earReturnChanged:)]) {
                [strongSelf.delegate earReturnChanged:isOn];
            }
        };
    }
    return _earReturnSwitch;
}


@end
