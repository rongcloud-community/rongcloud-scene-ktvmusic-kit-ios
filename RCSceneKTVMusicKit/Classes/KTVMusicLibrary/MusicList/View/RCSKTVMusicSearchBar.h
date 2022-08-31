//
// Created by xuefeng on 2022/7/7.
//

#import <UIKit/UIKit.h>


@interface RCSKTVMusicSearchBar : UIView

@property (nonatomic, weak, nullable) id<UISearchBarDelegate> delegate;
@property (nonatomic, assign) BOOL showsBookmarkButton; // default is NO.

@end

