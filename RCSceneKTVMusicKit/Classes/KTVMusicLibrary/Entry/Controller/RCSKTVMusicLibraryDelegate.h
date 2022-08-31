//
//  RCSKTVMusicLibraryDelegate.h
//  Pods
//
//  Created by 彭蕾 on 2022/7/15.
//
#import "RCSKTVRoomMusicProtocol.h"

@protocol RCSKTVMusicLibraryDelegate <NSObject>

@optional
/// 已点列表数据变化
- (void)selectedMusicListUpdated:(NSDictionary *)dataDic;

/// 申请置顶歌曲
- (void)applyForTopMusic:(id<RCSKTVRoomMusicProtocol>)model;

/// 点击控麦按钮
- (void)controlMic;

/// 删除歌成功
- (void)deleteMusic:(id<RCSKTVRoomMusicProtocol>)model;

/// 置顶歌成功
- (void)topMusic:(id<RCSKTVRoomMusicProtocol>)model;

/// 点歌成功
- (void)selectedMusic;

@end
