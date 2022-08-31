//
//  RCSNetworkDataHandler+KTVControl.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/8.
//

#import "RCSNetworkDataHandler+KTVMusicLibrary.h"
#import "RCSNetworkConfig+KTVMusicLibrary.h"

@implementation RCSNetworkDataHandler (KTVMusicLibrary)

#pragma mark - ktv 相关
/// 获取ktv房设置
- (void)ktvSettingWithParams:(NSDictionary * _Nullable)params
             completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig ktvSettingUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 点歌
- (void)ktvSongWithParams:(NSDictionary * _Nullable)params
          completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig ktvSongUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 置顶
- (void)pinKTVSongWithParams:(NSDictionary * _Nullable)params
             completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig pinKTVSongUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 切歌/删除点歌
- (void)delKTVSongWithParams:(NSDictionary * _Nullable)params
             completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig delKTVSongUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

#pragma mark - 音乐相关
/// 电台列表
- (void)musicChannelWithParams:(NSDictionary * _Nullable)params
               completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig musicChannelUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 电台获取歌单列表
- (void)musicChannelSheetWithParams:(NSDictionary * _Nullable)params
                    completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig musicChannelSheetUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 获取音乐HQ播放信息-K歌相关
- (void)musicKHQListenWithParams:(NSDictionary * _Nullable)params
                 completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig musicKHQListenUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 组合搜索
- (void)musicSearchConfigWithParams:(NSDictionary * _Nullable)params
                    completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig musicSearchUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

/// 歌单获取音乐列表
- (void)musicSheetConfigWithParams:(NSDictionary * _Nullable)params
                   completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig musicSheetUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

@end
