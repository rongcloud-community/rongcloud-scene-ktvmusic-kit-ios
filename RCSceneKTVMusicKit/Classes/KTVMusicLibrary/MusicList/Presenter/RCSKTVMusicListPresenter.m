//
//  RCSKTVMusicListPresenter.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import "RCSKTVMusicListPresenter.h"
#import "RCSNetworkDataHandler+KTVMusicLibrary.h"
#import "RCSKTVSongModel.h"
#import "RCSKTVMusicModel.h"
#import "RCSKTVDownloadManager.h"

@interface RCSKTVMusicListPresenter ()

@property (nonatomic, copy, readwrite) NSArray<id<RCSKTVSongProtocol> > *dataModels;
@property (nonatomic, assign, readwrite) BOOL noMoreData;
@property (nonatomic, strong) RCSNetworkDataHandler *dataHandler;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation RCSKTVMusicListPresenter

- (void)fetchMusicList:(NSString *)key
            isRefresh:(BOOL)isRefresh
      completionBlock:(void(^)(BOOL success))completionBlock {
    if (key.length == 0) {
        self.dataModels = nil;
        self.noMoreData = NO;
        !completionBlock ?: completionBlock(NO);
        return ;
    }
    
    if (isRefresh) {
        self.currentPage = 1;
    }
    
    if (self.isSearch) {
        [self fetchMusicListWithKeyword:key isRefresh:isRefresh completionBlock:completionBlock];
    } else {
        [self fetchMusicListWithCategoryId:key isRefresh:isRefresh completionBlock:completionBlock];
    }
}

- (void)fetchAndDownloadSongWithMusicId:(NSString *)musicId
                                   progress:(void(^)(NSProgress * _Nullable progress))progress
                            completionBlock:(void(^)(id<RCSKTVMusicProtocol> _Nullable model))completionBlock {
    [self fetchSongInfoWithMusicId:musicId
                   completionBlock:^(id<RCSKTVMusicProtocol>  _Nullable musicInfo) {
        if (!musicInfo) {
            return ;
        }
        [self downLoadMusicWithURL:musicInfo.fileUrl
                          progress:progress
                   completionBlock:^(NSString * _Nullable localPath) {
            musicInfo.fileUrl = localPath.copy;
            !completionBlock ?: completionBlock(musicInfo);
        }];
    }];
}

#pragma mark - private method
- (void)fetchSongInfoWithMusicId:(NSString *)musicId
                 completionBlock:(void(^)(id<RCSKTVMusicProtocol> _Nullable model))completionBlock {
    [self.dataHandler musicKHQListenWithParams:@{@"musicId": musicId ?: @""}
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

- (void)fetchMusicListWithCategoryId:(NSString *)categoryId
                          isRefresh:(BOOL)isRefresh
                    completionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.dataHandler musicSheetConfigWithParams:@{@"sheetId": categoryId ?: @"", @"page": @(self.currentPage)}
                                 completionBlock:^(RCSResponseModel * _Nonnull model) {
        
        StrongSelf(weakSelf);
        [strongSelf handleResultWithResponse:model
                                   isRefresh:isRefresh
                             completionBlock:completionBlock];
    }];
    
}

- (void)fetchMusicListWithKeyword:(NSString *)keyword
                       isRefresh:(BOOL)isRefresh
                 completionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.dataHandler musicSearchConfigWithParams:@{@"keyword": keyword, @"page": @(self.currentPage)}
                                 completionBlock:^(RCSResponseModel * _Nonnull model) {
        
        StrongSelf(weakSelf);
        [strongSelf handleResultWithResponse:model
                                   isRefresh:isRefresh
                             completionBlock:completionBlock];
    }];
}

- (void)handleResultWithResponse:(RCSResponseModel *)model
                       isRefresh:(BOOL)isRefresh
                 completionBlock:(void(^)(BOOL success))completionBlock {
    if (model.code != RCSResponseStatusCodeSuccess) {
        !completionBlock ?: completionBlock(NO);
        return ;
    }
    
    self.currentPage ++;
    RCSKTVMusicListModel *musicList = (RCSKTVMusicListModel *)model.data;
    NSArray<id<RCSKTVSongProtocol> > *newModels = musicList.record;
    if (isRefresh) {
        self.dataModels = newModels;
    } else {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dataModels];
        [tempArr addObjectsFromArray:newModels];
        self.dataModels = [tempArr yy_modelCopy];
    }
    self.noMoreData = (self.dataModels.count >= musicList.meta.totalCount);
    !completionBlock ?: completionBlock(YES);
}

- (void)downLoadLyricWithURL:(NSString *)url
             completionBlock:(void(^)(NSString * _Nullable localPath))completionBlock {
    [[RCSKTVDownloadManager shared] startDownloadWithUrl:url
                                            progress:nil
                                          completion:completionBlock];
}

- (void)downLoadMusicWithURL:(NSString *)url
                    progress:(void(^)(NSProgress * _Nullable progress))progress
             completionBlock:(void(^)(NSString * _Nullable localPath))completionBlock {
    [[RCSKTVDownloadManager shared] startDownloadWithUrl:url
                                            progress:progress
                                          completion:completionBlock];
}

#pragma mark - lazy load
- (RCSNetworkDataHandler *)dataHandler {
    if (!_dataHandler) {
        _dataHandler = [RCSNetworkDataHandler new];
    }
    return _dataHandler;
}

@end
