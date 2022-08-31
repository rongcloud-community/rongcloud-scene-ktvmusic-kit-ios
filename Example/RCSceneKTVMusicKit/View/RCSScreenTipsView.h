//
//  RCSScreenTipsView.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RCSScreenTipsViewStyle) {
    RCSScreenTipsViewStyleWelcome = 0, // 欢迎提示
    RCSScreenTipsViewStyleControlReady, // 控麦即将开始
    RCSScreenTipsViewStyleSingReady, // 演唱即将开始
    RCSScreenTipsViewStyleControling,  // 控麦中
    RCSScreenTipsViewStyleSingerWait, // 合唱-等待加入
    RCSScreenTipsViewStyleAudienceWait, // 合唱-加入合唱
};

@protocol RCSScreenTipsViewDelegate <NSObject>

/// 不等了，独唱
- (void)solo;

/// 邀请合唱
- (void)invite;

/// 加入合唱
- (void)join;

@end

@interface RCSScreenTipsView : UIView

@property (nonatomic, weak) id<RCSScreenTipsViewDelegate> delegate;
@property (nonatomic, assign) RCSScreenTipsViewStyle style;
@property (nonatomic, copy) NSString *songTitle;

- (void)updateReadyCountdownTime:(int)sec;
- (void)updateWaitingCountdownTime:(int)sec;

@end

NS_ASSUME_NONNULL_END
