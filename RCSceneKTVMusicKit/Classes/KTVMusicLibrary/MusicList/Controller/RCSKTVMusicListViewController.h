//
//  RCSKTVMusicListViewController.h
//  Pods
//
//  Created by xuefeng on 2022/7/6.
//

#import <UIKit/UIKit.h>
#import "RCSKTVMusicListSelectedDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicListViewController : UIViewController

@property (nonatomic, weak) id<RCSKTVMusicListSelectedDelegate> delegate;

/// 搜索结果展示
- (instancetype)initWithKeyword:(nullable NSString *)keyword;

/// 列表展示
- (instancetype)initWithCategoryId:(NSString *)categoryId;

- (void)searchWithKeyword:(nullable NSString *)keyword;

@end

NS_ASSUME_NONNULL_END
