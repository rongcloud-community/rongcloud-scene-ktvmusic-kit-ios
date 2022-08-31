//
//  RCSNetworkConfig+KTVControl.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/8.
//

#import <RCSceneNetworkKit/RCSNetworkKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSNetworkConfig (KTVMusicLibrary)

#pragma mark - ktv 相关
/// 获取ktv房设置
+ (RCSNetworkConfig *)ktvSettingUrlConfigWith:(NSDictionary *)params;

/// 点歌
+ (RCSNetworkConfig *)ktvSongUrlConfigWith:(NSDictionary *)params;

/// 置顶
+ (RCSNetworkConfig *)pinKTVSongUrlConfigWith:(NSDictionary *)params;

/// 切歌/删除点歌
+ (RCSNetworkConfig *)delKTVSongUrlConfigWith:(NSDictionary *)params;

#pragma mark - 音乐相关
/// 电台列表
+ (RCSNetworkConfig *)musicChannelUrlConfigWith:(NSDictionary *)params;

/// 电台获取歌单列表
+ (RCSNetworkConfig *)musicChannelSheetUrlConfigWith:(NSDictionary *)params;

/// 歌单获取音乐列表
+ (RCSNetworkConfig *)musicSheetUrlConfigWith:(NSDictionary *)params;

/// 获取音乐HQ播放信息-K歌相关
+ (RCSNetworkConfig *)musicKHQListenUrlConfigWith:(NSDictionary *)params;

/// 组合搜索
+ (RCSNetworkConfig *)musicSearchUrlConfigWith:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
