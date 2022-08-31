//
//  RCSKTVMusicSelectedDataProtocol.h
//  Pods
//
//  Created by 彭蕾 on 2022/7/13.
//

@protocol RCSKTVMusicSelectedDataProtocol <NSObject>

/// 演唱者名称
@property(nonatomic, copy) NSString *artistName;

/// 演唱者头像
@property(nonatomic, copy) NSString *userPortrait;

/// 歌曲名称
@property(nonatomic, copy) NSString *musicName;

/// 房间歌曲id，区别于musicId
@property(nonatomic, copy) NSString *songId;

/// 是否正在播放
@property(nonatomic, assign) BOOL isPlaying;

/// 是否独唱: 1 独唱 0 合唱 -1 控麦
@property(nonatomic, assign) int solo;

/// 删除
@property(nonatomic, assign) BOOL allowDelete;

/// 是否为控麦
@property(nonatomic, assign) BOOL isMicControl;

/// 置顶权限： 1 可直接置顶 0 申请置顶 -1 不能置顶
@property(nonatomic, assign) NSInteger pinPermission;

/// 已点歌曲 roomid
@property(nonatomic, copy) NSString *roomId;

/// 已点歌曲用户id
@property(nonatomic, copy) NSString *userId;

/// 版权方musicid
@property(nonatomic, copy) NSString *musicId;

@end
