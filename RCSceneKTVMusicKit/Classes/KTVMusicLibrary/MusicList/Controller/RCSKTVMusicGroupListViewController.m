//
//  RCSKTVMusicGroupListViewController.m
//  Pods
//
//  Created by xuefeng on 2022/7/6.
//

#import "RCSKTVMusicGroupListViewController.h"
#import "RCSKTVMusicSearchBar.h"
#import "RCSKTVMusicGroupCategoryView.h"
#import "RCSKTVMusicListViewController.h"
#import "RCSKTVMusicGroupCategoryModel.h"
#import "RCSKTVGroupListPresenter.h"

@interface RCSKTVMusicGroupListViewController ()
<UIScrollViewDelegate, RCSKTVMusicGroupCategoryViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) RCSKTVMusicSearchBar *searchBarView;
@property (nonatomic, strong) RCSKTVMusicGroupCategoryView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *controllersContainer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) RCSKTVGroupListPresenter *presenter;
@property (nonatomic, strong) RCSKTVMusicListViewController *searchResultVC;

@end

@implementation RCSKTVMusicGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;
    [self setupSubviews];
    [self fetchMusicData];
}

#pragma mark - SEARCHBAR DELEGATE
// 开始编辑弹出搜索列表
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.searchBarView.showsBookmarkButton = YES;
    self.searchResultVC.view.hidden = NO;
    self.categoryView.hidden = YES;
    self.scrollView.hidden = YES;
    return YES;
}

// 编辑结束搜索相应的keyword
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.searchResultVC searchWithKeyword:searchBar.text];
}

// 收起搜索列表
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [self.searchResultVC searchWithKeyword:nil];
    self.searchBarView.showsBookmarkButton = NO;
    self.searchResultVC.view.hidden = YES;
    self.categoryView.hidden = NO;
    self.scrollView.hidden = NO;
}

#pragma mark -PRIVATE METHOD
//获取音乐数据
- (void)fetchMusicData {
    WeakSelf(self);
    [self.presenter fetchGroupListWithCompletionBlock:^(BOOL success) {
        StrongSelf(weakSelf);
        if (!success) {
            return ;
        }
        strongSelf.categoryView.items = strongSelf.presenter.dataModels;
        [self addMusicListViewControllers:strongSelf.presenter.dataModels];
    }];
}

//添加分类的音乐列表 view
- (void)addMusicListViewControllers:(NSArray<id<RCSKTVMusicGroupCategoryProtocol>>*)items {
    UIView *leftView;
    for(RCSKTVMusicGroupCategoryModel *item in items) {
        RCSKTVMusicListViewController *musicListViewController = [[RCSKTVMusicListViewController alloc] initWithCategoryId:item.categoryId];
        musicListViewController.delegate = self.delegate;
        [self addChildViewController:musicListViewController];
        [self.controllersContainer addSubview:musicListViewController.view];
        [musicListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.bottom.equalTo(self.controllersContainer);
           if (leftView) {
               make.leading.equalTo(leftView.mas_trailing);
           } else{
               make.leading.equalTo(self.controllersContainer);
           }
           make.width.mas_equalTo(RCSKTVMusicScreenWidth);
        }];
        leftView = musicListViewController.view;
    }
    if (leftView) {
        [self.controllersContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(leftView.mas_trailing);
        }];
    }
}

- (void)toggleMusicList:(NSInteger)index {
    if (self.currentIndex == index) {return;}
    self.currentIndex = index;
    self.categoryView.selectedIndex = index;
}

#pragma mark - RCSKTVMusicGroupCategoryViewDelegate
- (void)toggleCategoryIndex:(NSInteger)index {
    if (self.currentIndex == index) {return;}
    self.currentIndex = index;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(index * kScreen_WIDTH, 0);
    }];
}

#pragma mark - SETUPVIEWS

- (void)setupSubviews {
    [self.view addSubview:self.searchBarView];
    [self.searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.view).offset(12);
        make.trailing.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(35);
    }];

    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.searchBarView.mas_bottom);
        make.height.mas_equalTo(44);
    }];

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];

    [self.scrollView addSubview:self.controllersContainer];
    [self.controllersContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    [self.view addSubview:self.searchResultVC.view];
    [self.searchResultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBarView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

#pragma mark - GETTER

- (RCSKTVMusicSearchBar *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[RCSKTVMusicSearchBar alloc] init];
        _searchBarView.layer.masksToBounds = YES;
        _searchBarView.layer.cornerRadius = 6;
        _searchBarView.delegate = self;
    }
    return _searchBarView;
}

- (RCSKTVMusicGroupCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[RCSKTVMusicGroupCategoryView alloc] init];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)controllersContainer {
    if (!_controllersContainer) {
        _controllersContainer = [[UIView alloc] init];
    }
    return _controllersContainer;
}

- (RCSKTVGroupListPresenter *)presenter {
    if (!_presenter) {
        _presenter = [RCSKTVGroupListPresenter new];
    }
    return _presenter;
}

- (RCSKTVMusicListViewController *)searchResultVC {
    if (!_searchResultVC) {
        _searchResultVC = [[RCSKTVMusicListViewController alloc] initWithKeyword:nil];
        _searchResultVC.view.hidden = YES;
    }
    return _searchResultVC;
}

#pragma mark - SCROLLVIEW DELEGATE

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/RCSKTVMusicScreenWidth;
    [self toggleMusicList:index];
}
@end
