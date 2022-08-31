//
//  RCSKTVMusicProtocol.h
//  RCSceneBaseKit
//
//  Created by 彭蕾 on 2022/7/12.
//

/// 歌曲详情模型
@protocol RCSKTVMusicProtocol<NSObject>

/// 歌曲id
@property(nonatomic, copy) NSString *musicId;

/// 歌曲url
@property(nonatomic, copy) NSString *fileUrl;

/// 动态歌词url
@property(nonatomic, copy) NSString *dynamicLyricUrl;

/// 静态歌词url
@property(nonatomic, copy) NSString *staticLyricUrl;

@end
