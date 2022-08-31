//
//  RCSScreenToolbar.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCSScreenToolbarDelegate <NSObject>

/// 展示调音面板
- (void)showTuner;

/// 切歌
- (void)skipTheSong;

/// 播放/暂停 歌曲
/// @param play  yes 播放，no 暂停
- (void)playTheSong:(BOOL)play;

/// 切换原/伴唱
/// @param origin  yes 原唱，no 伴唱
- (void)turnToOriginalSong:(BOOL)origin;

@end

@interface RCSScreenToolbar : UIView

@property (nonatomic, weak) id<RCSScreenToolbarDelegate> delegate;
@property (nonatomic, assign) BOOL isLead;
@property (nonatomic, assign) BOOL play;      /// 是否正在播放
@property (nonatomic, assign) BOOL origin;    /// 是否为原唱/伴唱

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
