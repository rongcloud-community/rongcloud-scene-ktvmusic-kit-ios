//
//  RCSKTVMusicGroupListViewController.h
//  Pods
//
//  Created by xuefeng on 2022/7/6.
//

#import <UIKit/UIKit.h>
#import "RCSKTVMusicListSelectedDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicGroupListViewController : UIViewController

@property (nonatomic, weak) id<RCSKTVMusicListSelectedDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
