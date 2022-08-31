//
// Created by xuefeng on 2022/7/8.
//

#import <UIKit/UIKit.h>
#import "RCSKTVMusicSelectedDataProtocol.h"
#import "RCSKTVRoomMusicProtocol.h"

@protocol RCSKTVMusicSelectedViewControllerDelegate <NSObject>

@optional
- (void)musicListUpdated:(NSDictionary *)musicData musicCount:(int)count;
- (void)applyForTopMusic:(id<RCSKTVRoomMusicProtocol>)model;
- (void)controlMic;
- (void)deleteMusic:(id<RCSKTVRoomMusicProtocol>)model;
- (void)topMusic:(id<RCSKTVRoomMusicProtocol>)model;

@end

@interface RCSKTVMusicSelectedViewController : UIViewController

@property (nonatomic, weak) id<RCSKTVMusicSelectedViewControllerDelegate> delegate;

/// 是否为独唱点歌，默认为YES
@property (nonatomic, assign) BOOL solo;
/// 当前播放的歌曲id
@property (nonatomic, copy) NSString *playingId;

/// 初始化
/// @param roomId  房间id
/// @param hadCreateRoom  是否创建了房间
/// @param currentUserId  当前登陆的用户id
/// @param currentUserName  当前登陆的用户名称
/// @param currentUserPortrait 当前登录的用户头像链接
- (instancetype)initWithRoomId:(NSString *)roomId
                 hadCreateRoom:(BOOL )hadCreateRoom
                 currentUserId:(NSString *)currentUserId
               currentUserName:(NSString *)currentUserName
           currentUserPortrait:(NSString *)currentUserPortrait;

/// 触发更新已点歌曲列表接口
- (void)fetchMusicListCompletionBlock:(void(^)(NSDictionary *dataDic))completionBlock;

/// 触发切歌/删除歌曲接口
- (void)deleteSong:(id<RCSKTVRoomMusicProtocol>)model
          completionBlock:(void(^)(BOOL success))completionBlock;

/// 触发置顶歌曲接口
- (void)topSong:(id<RCSKTVRoomMusicProtocol>)model
completionBlock:(void(^)(BOOL success))completionBlock;

/// 置顶控麦
- (void)topTheMicControlWithCompletionBlock:(void(^)(BOOL success))completionBlock;

/// 触发点歌接口
/// @param artistName 演唱者名称
/// @param musicId 歌曲id
/// @param musicName 歌曲名称
/// @param completionBlock 完成回调
- (void)selectedSongWithArtistName:(NSString *)artistName
                           musicId:(NSString *)musicId
                         musicName:(NSString *)musicName
                   completionBlock:(void(^)(BOOL success))completionBlock;

@end

