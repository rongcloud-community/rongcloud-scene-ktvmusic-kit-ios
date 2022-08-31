//
//  RCSLyricView.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import <UIKit/UIKit.h>
#import "RCSLyricParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSLyricView : UIView

/// 配置当前歌曲歌词
/// @param lyricURL  本地歌词URL
- (void)configCurrentSongWithURL:(NSURL *)lyricURL;

/// 配置当前歌曲歌词
/// @param lyricURL  本地歌词URL
/// @param parser  解析器
- (BOOL)configCurrentSongWithURL:(NSURL *)lyricURL
                     lyricParser:(RCSLyricParser *)parser;

/// 更新歌词滚动进度
- (void)updateCurrentPlayingTime:(CGFloat)currentTime;

/// 为了避免歌词更新的进度不够及时，内部会跑一个 displayLink 刷新UI
/// 当外部暂停/续播歌曲时，需要手动设置内部的动画
- (void)stopAnimation:(BOOL)stop;

@end

NS_ASSUME_NONNULL_END
