//
//  RCSKTVMusicSelectedPresenter.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/13.
//

#import <Foundation/Foundation.h>
#import "RCSKTVMusicSelectedDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicSelectedPresenter : NSObject

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign) int filter;
@property (nonatomic, copy) NSString *currentUserId;
@property (nonatomic, copy) NSString *currentUserName;
@property (nonatomic, copy) NSString *currentUserPortrait;
@property (nonatomic, assign) int solo;
@property (nonatomic, copy) NSString *playingMusicId;
@property (nonatomic, copy, readonly) NSArray<id<RCSKTVMusicSelectedDataProtocol>> *dataModels;
@property (nonatomic, assign, readonly) BOOL isHost; // 是否为房主
@property (nonatomic, assign, readonly) BOOL hasControlMic; // 是否有控麦

- (void)fetchKTVRoomSettingWithCompletionBlock:(void(^)(BOOL success, NSDictionary *dataDic))completionBlock;

- (void)selectedSongWithArtistName:(NSString *)artistName
                           musicId:(NSString *)musicId
                         musicName:(NSString *)musicName
                   completionBlock:(void(^)(BOOL success))completionBlock;


/// 置顶
- (void)pinTheSong:(NSString *)songId
   completionBlock:(void(^)(BOOL success))completionBlock;

/// 删除
- (void)deleteTheSong:(NSString *)songId
      completionBlock:(void(^)(BOOL success))completionBlock;

@end

NS_ASSUME_NONNULL_END
