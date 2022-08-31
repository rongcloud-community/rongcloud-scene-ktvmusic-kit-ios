//
// Created by xuefeng on 2022/7/8.
//

#import <UIKit/UIKit.h>
#import "RCSKTVSongProtocol.h"
@class RCSKTVMusicListCell;
@protocol RCSKTVMusicListCellDelegate <NSObject>

- (void)musicListCell:(RCSKTVMusicListCell *)cell selectedMusic:(id<RCSKTVSongProtocol>)model;

@end

@interface RCSKTVMusicListCell : UITableViewCell

@property (nonatomic, weak) id<RCSKTVMusicListCellDelegate> delegate;
@property (nonatomic, copy, class, readonly) NSString *identifier;

- (void)updateUIWithModel:(id<RCSKTVSongProtocol>)model;
- (void)updateLoadingProgress:(int)progress;

@end
