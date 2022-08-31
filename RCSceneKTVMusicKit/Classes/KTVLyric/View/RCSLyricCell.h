//
//  RCSLyricCell.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import <UIKit/UIKit.h>
#import "RCSLyricModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 单句歌词
@interface RCSLyricCell : UITableViewCell

/// 逐句/逐字模型：RCSSentenceModel / RCSELrcSentenceModel
@property (nonatomic, strong) RCSSentenceModel *sentence;


/// 设置歌词
/// @param content  单句歌词
- (void)setUpContent:(NSString *)content;

/// 正在播放，用于动态歌词滚动
/// @param isPlaying  是否正播放到此句歌词
- (void)isPlaying:(BOOL)isPlaying;


/// 更新逐字滚动歌词状态，用于逐字歌词，需要实时更新
/// @param currentTime  当前播放的歌曲时间
- (void)updateTextWithCurrentTime:(CGFloat)currentTime;

@end

NS_ASSUME_NONNULL_END
