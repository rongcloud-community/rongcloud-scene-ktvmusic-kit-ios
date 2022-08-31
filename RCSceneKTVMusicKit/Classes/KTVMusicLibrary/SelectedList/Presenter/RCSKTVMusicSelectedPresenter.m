//
//  RCSKTVMusicSelectedPresenter.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/13.
//

#import "RCSKTVMusicSelectedPresenter.h"
#import "RCSNetworkDataHandler+KTVMusicLibrary.h"
#import "RCSKTVRoomModel.h"

@interface RCSKTVMusicSelectedPresenter ()

@property (nonatomic, copy, readwrite) NSArray<id<RCSKTVMusicSelectedDataProtocol>> *dataModels;
@property (nonatomic, assign, readwrite) BOOL isHost;
@property (nonatomic, assign, readwrite) BOOL hasControlMic;
@property (nonatomic, strong) RCSNetworkDataHandler *dataHandler;

@end

@implementation RCSKTVMusicSelectedPresenter

- (void)fetchKTVRoomSettingWithCompletionBlock:(void(^)(BOOL success, NSDictionary * _Nullable dataDic))completionBlock {
    WeakSelf(self);
    NSDictionary *params = @{@"roomId": self.roomId ?: @"", @"filter":@(self.filter)};
    [self.dataHandler ktvSettingWithParams:params
                           completionBlock:^(RCSResponseModel * _Nonnull model) {
        if (model.code != RCSResponseStatusCodeSuccess) {
            [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
            !completionBlock ?: completionBlock(NO, nil);
            return ;
        }
        
        StrongSelf(weakSelf);
        [strongSelf handleResultWithResponse:model completionBlock:completionBlock];
    }];
}

#pragma mark - private method
- (void)handleResultWithResponse:(RCSResponseModel *)model
                 completionBlock:(void(^)(BOOL success, NSDictionary *dataDic))completionBlock {
    NSDictionary *dataDic = (NSDictionary *)model.data;
    RCSKTVRoomModel *ktvRoom = [RCSKTVRoomModel yy_modelWithJSON:dataDic];
    self.isHost = [ktvRoom.userId isEqualToString:self.currentUserId];
    self.hasControlMic = (ktvRoom.seat > 0);
    NSMutableArray<id<RCSKTVMusicSelectedDataProtocol>> *musicList = [NSMutableArray arrayWithCapacity:ktvRoom.songQueue.count];
    int i = 0;
    for (RCSKTVMusicSelectedModel *model in ktvRoom.songQueue) {
        BOOL isHost = [ktvRoom.userId isEqualToString:self.currentUserId];
        BOOL isMyOrder = [model.userId isEqualToString:self.currentUserId];
        model.allowDelete = (isHost || isMyOrder);
        model.pinPermission = isHost ? 1 : (isMyOrder ? 0 : -1);
        model.isPlaying = [self.playingMusicId isEqualToString:model.musicId];
        model.isMicControl = [model.songId isEqualToString:RCSKTVMusicControlMicSongId];
        [musicList addObject:model];
        i++;
    }
    
    self.dataModels = [musicList yy_modelCopy];
    !completionBlock ?: completionBlock(YES, model.data);
}

/// 点歌
- (void)selectedSongWithArtistName:(NSString *)artistName
                           musicId:(NSString *)musicId
                         musicName:(NSString *)musicName
                   completionBlock:(void(^)(BOOL success))completionBlock {
    RCSKTVRoomMusicModel *songModel = [RCSKTVRoomMusicModel new];
    songModel.roomId = self.roomId;
    songModel.solo = self.solo;
    songModel.userId = self.currentUserId;
    songModel.userPortrait = self.currentUserPortrait;
    songModel.artistName = artistName;
    songModel.musicId = musicId;
    songModel.musicName = musicName;
    NSDictionary *dic = [songModel yy_modelToJSONObject];
    [self.dataHandler ktvSongWithParams:dic
                        completionBlock:^(RCSResponseModel * _Nonnull model) {
        !completionBlock ?: completionBlock(model.code == RCSResponseStatusCodeSuccess);
    }];
}

/// 置顶
- (void)pinTheSong:(NSString *)songId completionBlock:(void(^)(BOOL success))completionBlock {
    if (songId.length == 0) {
        !completionBlock ?: completionBlock(NO);
        return ;
    }
    
    NSDictionary *params = nil;
    if ([songId isEqualToString:RCSKTVMusicControlMicSongId]) {
        params = @{@"roomId": self.roomId,
                   @"songId": songId,
                   @"musicName": @"控麦",
                   @"userId": self.currentUserId,
                   @"userPortrait":self.currentUserPortrait,
                   @"artistName":self.currentUserName };
    } else {
        params = @{
            @"roomId": self.roomId,
            @"songId": songId
        };
    }
    
    [self.dataHandler pinKTVSongWithParams:params
                           completionBlock:^(RCSResponseModel * _Nonnull model) {
        !completionBlock ?: completionBlock(model.code == RCSResponseStatusCodeSuccess);
    }];
}

/// 删除
- (void)deleteTheSong:(NSString *)songId completionBlock:(void(^)(BOOL success))completionBlock {
    if (songId.length == 0) {
        !completionBlock ?: completionBlock(NO);
        return ;
    }
    NSDictionary *params = @{@"roomId": self.roomId, @"songId": songId};
    [self.dataHandler delKTVSongWithParams:params
                           completionBlock:^(RCSResponseModel * _Nonnull model) {
        !completionBlock ?: completionBlock(model.code == RCSResponseStatusCodeSuccess);
    }];
}

#pragma mark - lazy load
- (RCSNetworkDataHandler *)dataHandler {
    if (!_dataHandler) {
        _dataHandler = [RCSNetworkDataHandler new];
    }
    return _dataHandler;
}

@end
