//
// Created by xuefeng on 2022/7/8.
//

#import <UIKit/UIKit.h>
#import "RCSKTVMusicLibraryConfig.h"
#import "RCSKTVMusicGroupListViewController.h"
#import "RCSKTVMusicSelectedViewController.h"
#import "RCSKTVMusicLibraryDelegate.h"

@interface RCSKTVMusicLibraryViewController : UIViewController

@property  (nonatomic, strong, readonly) RCSKTVMusicGroupListViewController   *musicGroupListViewController;
@property  (nonatomic, strong, readonly) RCSKTVMusicSelectedViewController    *musicSelectedViewController;

/// 是否为独唱点歌，默认为YES
@property (nonatomic, assign) BOOL solo;

/// 当前选择列表：0：歌曲  1：已点
@property (nonatomic, assign) int seletectedIndex;

/// 当前播放的歌曲id
@property (nonatomic, copy) NSString *playingId;

@property (nonatomic, weak) id<RCSKTVMusicLibraryDelegate> delegate;

- (instancetype)initWithConfig:(RCSKTVMusicLibraryConfig *)config;

@end
