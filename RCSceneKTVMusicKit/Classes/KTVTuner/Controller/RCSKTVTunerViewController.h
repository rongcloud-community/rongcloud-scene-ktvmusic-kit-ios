//
//  RCSKTVTunerViewController.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import <UIKit/UIKit.h>
#import "RCSKTVTunerConfig.h"
#import "RCSReverbItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCSKTVTunerViewControllerDelegate <NSObject>

@optional

/// 混响音效
- (void)reverbChanged:(NSInteger )index;

/// 伴奏音量
- (void)accompVolumeChanged:(float)value;

/// 人声音量
- (void)vocalVolumeChanged:(float)value;

/// 耳返
- (void)earReturnChanged:(BOOL)isOn;

/**
 1.0 版本不做升降调 & 音准器
 */
/// 升降调
- (void)toneStepperChanged:(int)value;

/// 音准器
- (void)pincherChanged:(BOOL)isOn;

@end

@class RCSKTVTunerViewController;
@protocol RCSKTVTunerViewControllerDataSource <NSObject>
@required
// 配置混响类型名称
- (NSArray<id<RCSReverbItemProtocol>> *)reverbItemsInTunerViewController:(RCSKTVTunerViewController *)tunerVC;

@end

@interface RCSKTVTunerViewController : UIViewController

@property (nonatomic, weak) id<RCSKTVTunerViewControllerDelegate> delegate;
@property (nonatomic, weak) id<RCSKTVTunerViewControllerDataSource> dataSource;
@property (nonatomic, strong) RCSKTVTunerConfig *config;

- (instancetype)initWithConfig:(nullable RCSKTVTunerConfig *)config;


/// 展示调音台
/// @param vc  从vc展示 present 出来
- (void)showIn:(nonnull UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
