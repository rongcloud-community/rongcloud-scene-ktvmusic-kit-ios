//
//  RCSNetworkConfig+KTVControl.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/8.
//

#import "RCSNetworkConfig+KTVMusicLibrary.h"
#import "RCSKTVMusicLibraryConfig.h"

@implementation RCSNetworkConfig (KTVMusicLibrary)

#pragma mark - ktv 相关
/// 获取ktv房设置
+ (RCSNetworkConfig *)ktvSettingUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/ktv/setting"]
                  rspClassName:nil
                        method:RCSHTTPRequestMethodGET
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 点歌
+ (RCSNetworkConfig *)ktvSongUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/ktv/song"]
                  rspClassName:nil
                        method:RCSHTTPRequestMethodPOST
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 置顶
+ (RCSNetworkConfig *)pinKTVSongUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/ktv/song"]
                  rspClassName:nil
                        method:RCSHTTPRequestMethodPUT
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 切歌/删除点歌
+ (RCSNetworkConfig *)delKTVSongUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/ktv/song/del"]
                  rspClassName:nil
                        method:RCSHTTPRequestMethodPUT
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

#pragma mark - 音乐相关
/// 电台列表
+ (RCSNetworkConfig *)musicChannelUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/music/channel"]
                  rspClassName:nil
                        method:RCSHTTPRequestMethodGET
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 电台获取歌单列表
+ (RCSNetworkConfig *)musicChannelSheetUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/music/channelSheet"]
                  rspClassName:@"RCSKTVChannelSheetModel"
                        method:RCSHTTPRequestMethodGET
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 获取音乐HQ播放信息-K歌相关
+ (RCSNetworkConfig *)musicKHQListenUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/music/kHQListen"]
                  rspClassName:@"RCSKTVMusicModel"
                        method:RCSHTTPRequestMethodGET
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 组合搜索
+ (RCSNetworkConfig *)musicSearchUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/music/searchMusic"]
                  rspClassName:@"RCSKTVMusicListModel"
                        method:RCSHTTPRequestMethodPOST
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

/// 歌单获取音乐列表
+ (RCSNetworkConfig *)musicSheetUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:[self ktvMusicLibrary_fullUrlWithPath:@"/mic/music/sheetMusic"]
                  rspClassName:@"RCSKTVMusicListModel"
                        method:RCSHTTPRequestMethodGET
                        params:params
                       headers:[self ktvMusicLibrary_commonHeaders]];
}

#pragma mark - private method
+ (NSString *)ktvMusicLibrary_fullUrlWithPath:(NSString *)path {
    return [[RCSKTVMusicLibraryConfig baseUrl] stringByAppendingString:path];
}

+ (NSDictionary *)ktvMusicLibrary_commonHeaders {
    NSMutableDictionary *header = @{@"Content-Type":@"application/json"}.mutableCopy;
    if ([RCSKTVMusicLibraryConfig businessToken].length != 0) {
        [header addEntriesFromDictionary:@{@"BusinessToken":[RCSKTVMusicLibraryConfig businessToken]}];
    }
    if ([RCSKTVMusicLibraryConfig auth].length != 0) {
        [header addEntriesFromDictionary:@{@"Authorization":[RCSKTVMusicLibraryConfig auth]}];
    }
    return header.copy;
}

@end
