//
// Created by xuefeng on 2022/7/7.
//

#import "RCSKTVMusicSearchBar.h"

@interface RCSKTVMusicSearchBar()
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation RCSKTVMusicSearchBar
- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setDelegate:(id<UISearchBarDelegate>)delegate {
    _delegate = delegate;
    _searchBar.delegate = delegate;
}

- (void)setShowsBookmarkButton:(BOOL)showsBookmarkButton {
    _showsBookmarkButton = showsBookmarkButton;
    _searchBar.showsBookmarkButton = showsBookmarkButton;
}

#pragma mark SETUPSUBVIEWS

- (void)setupSubviews {
    self.backgroundColor = [UIColor rcs_colorWithHex:0xF9F9F9];
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark GETTER
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索歌曲或歌手";
        _searchBar.delegate = self.delegate;
        _searchBar.tintColor = RCSKTVMusicMainColor;
        [_searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        [_searchBar setSearchFieldBackgroundImage:[UIImage rcs_imageWithColor:[UIColor rcs_colorWithHex:0xF9F9F9] size:CGSizeMake(500, 100)] forState:UIControlStateNormal];
        [_searchBar setImage:RCSKTVMusicImageNamed(@"music_close")
            forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        [_searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconBookmark];
        if (@available(iOS 13.0, *)) {
            _searchBar.searchTextField.borderStyle = UITextBorderStyleNone;
            _searchBar.searchTextField.layer.masksToBounds = YES;
            _searchBar.searchTextField.layer.cornerRadius = 10;
            _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
            _searchBar.searchTextField.textColor = [UIColor rcs_colorWithHex:0xB2B2B2];
        } else {
            for (UIView *view in _searchBar.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
                    view.layer.cornerRadius = 10.0f;
                    view.layer.masksToBounds = YES;
                } else if ([view isKindOfClass:NSClassFromString(@"UITextField")]) {
                    UITextField *tf = (UITextField*)view;
                    tf.font = [UIFont systemFontOfSize:12];
                    tf.textColor = [UIColor rcs_colorWithHex:0xB2B2B2];
                }
            }
        }
    }
    return _searchBar;
}

@end
