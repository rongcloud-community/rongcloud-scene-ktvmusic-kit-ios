//
//  RCSLyricLabel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 遮罩label
@interface RCSLyricLabel : UILabel

/// 当前mask进度，用于逐字歌词
@property (nonatomic, assign) CGFloat progress;

/// 是否显示mask
/// @param mask  逐字yes，逐句no
- (void)shouldLoadMask:(BOOL)mask;

@end

NS_ASSUME_NONNULL_END
