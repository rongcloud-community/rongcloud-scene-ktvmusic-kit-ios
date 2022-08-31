//
//  RCSKTVScreen.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 用户角色
typedef NS_ENUM(NSUInteger, RCSKTVScreenRole) {
    RCSKTVScreenRoleAudience = 0, // 观众
    RCSKTVScreenRoleSinger = 1, // 副唱
    RCSKTVScreenRoleLeadSinger = 2, // 主唱
};

@protocol RCSKTVScreenDelegate <NSObject>
/// 展示调音面板
- (void)showTuner;

/// 切歌
- (void)nextSong;

/// 播放/暂停 歌曲
/// @param isPlay  yes播放，no 暂停
- (void)play:(BOOL)isPlay;

/// 切换原/伴唱
/// @param isOrigin  yes 原唱，no 伴唱
- (void)turnToOriginSong:(BOOL)isOrigin;

@end

@interface RCSKTVScreen : UIImageView

@property (nonatomic, weak) id<RCSKTVScreenDelegate> delegate;
@property (nonatomic, assign) BOOL play;   /// 是否播放
@property (nonatomic, assign) BOOL origin;    /// 是否为原唱/伴唱

/// 切歌
/// @param lyricURL 本地歌词路径
/// @param role  当前角色
- (void)resetScreenWithLyricURL:(nullable NSURL *)lyricURL role:(RCSKTVScreenRole)role;

/// 更新歌曲进度，用于歌词滚动
/// @param currentTime  当前歌曲播放时间：【mix progress * 歌曲总时长】
- (void)updateScreenWithCurrentTime:(CGFloat)currentTime;

@end

NS_ASSUME_NONNULL_END
