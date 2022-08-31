//
//  RCSKTVRoomMusicProtocol.h
//  Pods
//
//  Created by 彭蕾 on 2022/7/18.
//

@protocol RCSKTVRoomMusicProtocol <NSObject>

/// 艺术家名称
@property(nonatomic, copy) NSString *artistName;

/// 音乐平台的歌曲id
@property(nonatomic, copy) NSString *musicId;

/// 歌曲名称
@property(nonatomic, copy) NSString *musicName;

/// 房间id
@property(nonatomic, copy) NSString *roomId;

/// 独唱/合唱
@property(nonatomic, assign) int solo;

/// ktv房间生成的歌曲id
@property(nonatomic, copy) NSString *songId;

/// 用户id
@property(nonatomic, copy) NSString *userId;

/// 用户头像
@property(nonatomic, copy) NSString *userPortrait;

@end
