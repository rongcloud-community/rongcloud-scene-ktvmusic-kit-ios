//
//  RCSKTVMusicSelectedCell.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/11.
//

#import <UIKit/UIKit.h>
#import "RCSKTVMusicSelectedDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCSKTVMusicSelectedCellDelegate <NSObject>

- (void)pinTheSong:(NSInteger)row;
- (void)deleteTheSong:(NSInteger)row;

@end

@interface RCSKTVMusicSelectedCell : UITableViewCell

@property (nonatomic, weak) id<RCSKTVMusicSelectedCellDelegate> delegate;
@property (nonatomic, copy, class, readonly) NSString *identifier;

- (void)updateUIWithModel:(id<RCSKTVMusicSelectedDataProtocol>)model row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
