//
//  RCSKTVMusicListSelectedDelegate.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/14.
//

#import "RCSKTVSongProtocol.h"

@protocol RCSKTVMusicListSelectedDelegate <NSObject>

/// 点歌
- (void)selectedSong:(id<RCSKTVSongProtocol>)song;

@end
