//
// Created by xuefeng on 2022/7/7.
//

#import <UIKit/UIKit.h>
#import "RCSKTVMusicGroupCategoryProtocol.h"

@protocol RCSKTVMusicGroupCategoryViewDelegate <NSObject>

- (void)toggleCategoryIndex:(NSInteger)index;

@end

@interface RCSKTVMusicGroupCategoryView : UIView

@property (nonatomic, weak) id<RCSKTVMusicGroupCategoryViewDelegate> delegate;
@property (nonatomic, copy) NSArray<id<RCSKTVMusicGroupCategoryProtocol>> *items;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
