//
//  RCSKTVMusicLibrary.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/15.
//

#import "RCSKTVMusicLibrary.h"
#import "RCSKTVMusicLibraryViewController.h"
#import "RCSKTVMusicSelectedViewController.h"
#import "RCSNetworkDataHandler+KTVMusicLibrary.h"
#import "RCSKTVDownloadManager.h"
#import "RCSKTVMusicModel.h"

@interface RCSKTVMusicLibrary ()

@property (nonatomic, strong) RCSKTVMusicLibraryViewController *musicLibraryVC;
@property (nonatomic, strong, readwrite) RCSKTVMusicLibraryConfig *config;


@end

@implementation RCSKTVMusicLibrary
- (instancetype)initWithConfig:(RCSKTVMusicLibraryConfig *)config {
    if (self = [super init]) {
        self.config = config;
    }
    return self;
}

- (void)setDelegate:(id<RCSKTVMusicLibraryDelegate>)delegate {
    self.musicLibraryVC.delegate = delegate;
}

- (void)showMusicLibraryInViewController:(UIViewController *)viewController
                                  isSolo:(BOOL)solo
                         seletectedIndex:(int)seletectedIndex
                               playingId:(nullable NSString *)playingId {
    self.musicLibraryVC.solo = solo;
    self.musicLibraryVC.seletectedIndex = seletectedIndex;
    self.musicLibraryVC.playingId = playingId;
    [viewController presentViewController:self.musicLibraryVC animated:YES completion:nil];
}

- (void)setPlayingId:(NSString *)playingId {
    _playingId = playingId;
    self.musicLibraryVC.playingId = playingId;
}

/// 触发更新已点歌曲列表接口
- (void)fetchSelectedMusicListCompletionBlock:(void(^)(NSDictionary *dataDic))completionBlock {
    [self.musicLibraryVC.musicSelectedViewController fetchMusicListCompletionBlock:completionBlock];
}

/// 触发切歌/删除歌曲接口
- (void)deleteMusic:(id<RCSKTVRoomMusicProtocol>)model completionBlock:(void(^)(BOOL success))completionBlock {
    [self.musicLibraryVC.musicSelectedViewController deleteSong:model
                                                completionBlock:completionBlock];
}

/// 触发置顶歌曲接口
- (void)topMusic:(id<RCSKTVRoomMusicProtocol>)model
 completionBlock:(void(^)(BOOL success))completionBlock {
    [self.musicLibraryVC.musicSelectedViewController topSong:model
                                                       completionBlock:completionBlock];
}

/// 控麦动作完成后，触发置顶歌曲接口，置顶控麦
- (void)topMicControlWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    [self.musicLibraryVC.musicSelectedViewController topTheMicControlWithCompletionBlock:completionBlock];
}

#pragma mark - lazy load
- (RCSKTVMusicLibraryViewController *)musicLibraryVC {
    if (!_musicLibraryVC) {
        _musicLibraryVC = [[RCSKTVMusicLibraryViewController alloc] initWithConfig:self.config];
    }
    return _musicLibraryVC;
}

#pragma mark - class method
+ (void)fetchMusicInfoWithMusicId:(NSString *)musicId
                  completionBlock:(void(^)(id<RCSKTVMusicProtocol> _Nullable model))completionBlock {
    [[RCSNetworkDataHandler new] musicKHQListenWithParams:@{@"musicId": musicId ?: @""}
                                          completionBlock:^(RCSResponseModel * _Nonnull model) {
        if (model.code != RCSResponseStatusCodeSuccess) {
            [SVProgressHUD showErrorWithStatus:@"获取歌曲信息失败"];
            !completionBlock ?: completionBlock(nil);
            return ;
        }
        RCSKTVMusicModel *music = (RCSKTVMusicModel *)model.data;
        !completionBlock ?: completionBlock(music);
    }];
}

/// 本地资源文件是否存在
/// @param fileUrl 下载地址
+ (BOOL)isExistWithURL:(NSString *)fileUrl {
    return ([[RCSKTVDownloadManager shared] localPathExistWithURL:fileUrl].length != 0);
}

/// 本地资源文件
/// @param fileUrl 下载地址，存在则返回本地路径，不存在则返回空，业务方可调用 downloadFileWithUrl 下载
+ (nullable NSString *)localPathExistWithURL:(NSString *)fileUrl {
    return [[RCSKTVDownloadManager shared] localPathExistWithURL:fileUrl];
}

+ (void)downloadFileWithUrl:(NSString *)url
                   progress:(void(^)(NSProgress * _Nullable progress))loadProgress
                 completion:(void(^)(NSString * _Nullable localPath))completion {
    [[RCSKTVDownloadManager shared] startDownloadWithUrl:url progress:loadProgress completion:completion];
}


@end
