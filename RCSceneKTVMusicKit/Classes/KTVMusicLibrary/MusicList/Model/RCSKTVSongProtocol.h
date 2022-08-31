//
//  RCSKTVSongProtocol.h
//  Pods
//
//  Created by 彭蕾 on 2022/7/12.
//

/// 歌曲列表 UI
@protocol RCSKTVSongProtocol<NSObject>

/// 歌曲id
@property(nonatomic, copy) NSString *musicId;

/// 歌曲名称
@property(nonatomic, copy) NSString *musicName;

/// 歌曲演唱者
@property(nonatomic, copy) NSString *artistName;

/// 歌曲封面
@property(nonatomic, copy) NSString *coverUrl;

@end
