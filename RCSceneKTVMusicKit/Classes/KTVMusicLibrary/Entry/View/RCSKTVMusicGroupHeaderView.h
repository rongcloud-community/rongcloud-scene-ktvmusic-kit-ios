//
//  RCSKTVMusicGroupHeaderView.h
//  RCSceneKTVMusicKit
//
//  Created by xuefeng on 2022/7/7.
//

#import <UIKit/UIKit.h>

/// 当前列表类型
typedef NS_ENUM(NSUInteger, RCSKTVMusicGroupHeaderType) {
    RCSKTVMusicGroupHeaderTypeMusicList = 0,
    RCSKTVMusicGroupHeaderTypeSelected = 1,
};

typedef void (^RCSKTVMusicGroupHeaderSelectClosure)(RCSKTVMusicGroupHeaderType);

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicGroupHeaderView : UIView

@property (nonatomic, copy) RCSKTVMusicGroupHeaderSelectClosure closure;
@property (nonatomic, assign) RCSKTVMusicGroupHeaderType type;

- (void)updateTitle:(NSString *)title withType:(RCSKTVMusicGroupHeaderType)type;

@end

NS_ASSUME_NONNULL_END
