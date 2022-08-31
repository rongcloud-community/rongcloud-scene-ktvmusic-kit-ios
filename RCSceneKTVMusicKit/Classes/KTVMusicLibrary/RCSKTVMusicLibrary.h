//
//  RCSKTVMusicLibrary.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/15.
//

#import <Foundation/Foundation.h>
#import "RCSKTVMusicLibraryConfig.h"
#import "RCSKTVMusicProtocol.h"
#import "RCSKTVRoomMusicProtocol.h"
#import "RCSKTVMusicLibraryDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicLibrary : NSObject

/// 当前播放的歌曲id
@property (nonatomic, copy) NSString *playingId;

/// 代理
@property (nonatomic, weak) id<RCSKTVMusicLibraryDelegate> delegate;

/// 初始化
- (instancetype)initWithConfig:(RCSKTVMusicLibraryConfig *)config NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 展示点歌台
/// @param viewController  当前VC
/// @param solo 是否为独唱点歌
/// @param seletectedIndex 当前选择列表：0：歌曲  1：已点
/// @param playingId 当前播放的歌曲id
- (void)showMusicLibraryInViewController:(UIViewController *)viewController
                                  isSolo:(BOOL)solo
                         seletectedIndex:(int)seletectedIndex
                               playingId:(nullable NSString *)playingId;

/// 触发更新已点歌曲列表接口
- (void)fetchSelectedMusicListCompletionBlock:(nullable void(^)(NSDictionary *dataDic))completionBlock;

/// 删除歌曲接口
- (void)deleteMusic:(id<RCSKTVRoomMusicProtocol>)model completionBlock:(void(^)(BOOL success))completionBlock;

/// 置顶歌曲
- (void)topMusic:(id<RCSKTVRoomMusicProtocol>)model completionBlock:(void(^)(BOOL success))completionBlock;

/// 控麦动作完成后，触发置顶歌曲接口，置顶控麦
- (void)topMicControlWithCompletionBlock:(void(^)(BOOL success))completionBlock;

/// 查询当前歌曲信息
/// @param musicId 歌曲id
/// @param completionBlock 查询结果回调
+ (void)fetchMusicInfoWithMusicId:(NSString *)musicId
                 completionBlock:(void(^)(id<RCSKTVMusicProtocol> _Nullable model))completionBlock;

/// 资源文件下载
/// @param url 下载地址
/// @param loadProgress 下载进度
/// @param completion 下载完成回调，返回本地路径
+ (void)downloadFileWithUrl:(NSString *)url
                   progress:(void(^)(NSProgress * _Nullable progress))loadProgress
                 completion:(void(^)(NSString * _Nullable localPath))completion;


@end

NS_ASSUME_NONNULL_END
