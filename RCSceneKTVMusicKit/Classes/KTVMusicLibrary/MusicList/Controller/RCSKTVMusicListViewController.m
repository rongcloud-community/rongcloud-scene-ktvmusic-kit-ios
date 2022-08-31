//
//  RCSKTVMusicListViewController.m
//  Pods
//
//  Created by xuefeng on 2022/7/6.
//

#import "RCSKTVMusicListViewController.h"
#import "RCSKTVMusicListCell.h"
#import "RCSKTVMusicListPresenter.h"
#import <MJRefresh/MJRefresh.h>

@interface RCSKTVMusicListViewController () <UITableViewDataSource, UITableViewDelegate, RCSKTVMusicListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, strong) RCSKTVMusicListPresenter *presenter;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) UIImageView *emptyImageView;

@end

@implementation RCSKTVMusicListViewController

- (instancetype)initWithKeyword:(NSString *)keyword {
    if (self = [super init]) {
        self.keyword = keyword;
        self.presenter.isSearch = YES;
    }
    return self;
}

- (instancetype)initWithCategoryId:(NSString *)categoryId {
    if (self = [super init]) {
        self.categoryId = categoryId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    [self fetchData:YES];
    
    WeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(weakSelf);
        [strongSelf fetchData:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        StrongSelf(weakSelf);
        [strongSelf fetchData:NO];
    }];
}

- (void)searchWithKeyword:(NSString *)keyword {
    self.keyword = keyword;
    [self fetchData:YES];
}


#pragma mark - PRIVATE METHOD
/// 请求数据
- (void)fetchData:(BOOL)isRefresh {
    WeakSelf(self);
    [self.presenter fetchMusicList:self.presenter.isSearch ? self.keyword : self.categoryId
                        isRefresh:isRefresh
                  completionBlock:^(BOOL success) {
        StrongSelf(weakSelf);
        if (strongSelf.presenter.noMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [strongSelf.tableView.mj_header endRefreshing];
        strongSelf.emptyImageView.hidden = (strongSelf.presenter.dataModels.count != 0);
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - SETUPSUBVIEWS

- (void)setupViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.trailing.bottom.leading.equalTo(self.view);
    }];
}

#pragma mark - GETTER

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[RCSKTVMusicListCell class] forCellReuseIdentifier:[RCSKTVMusicListCell identifier]];
        [_tableView addSubview:self.emptyImageView];
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
        self.emptyImageView.hidden = YES;
    }
    return _tableView;
}

- (RCSKTVMusicListPresenter *)presenter {
    if (!_presenter) {
        _presenter = [RCSKTVMusicListPresenter new];
    }
    return _presenter;
}

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [UIImageView new];
        _emptyImageView.image = RCSKTVMusicImageNamed(@"list_empty");
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        label.textColor = [UIColor whiteColor];
        label.text = self.presenter.isSearch ? @"未找到搜索结果" : @"暂无歌曲";
        [_emptyImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.offset(-12);
        }];
    }
    return _emptyImageView;
}

#pragma mark - RCSKTVMusicListCellDelegate
- (void)musicListCell:(RCSKTVMusicListCell *)cell selectedMusic:(id<RCSKTVSongProtocol>)musicModel {
    
    /// 1. 先下载歌曲
    WeakSelf(self);
    [self.presenter fetchAndDownloadSongWithMusicId:musicModel.musicId
                                           progress:^(NSProgress * _Nullable progress) {
        float pro = progress.completedUnitCount/(progress.totalUnitCount*1.0);
        [cell updateLoadingProgress:(int)ceil(pro*100)];
    } completionBlock:^(id<RCSKTVMusicProtocol>  _Nullable model) {
        if (!model) {
            return ;
        }
        
        /// 2. 下载成功，再调用服务器的点歌接口
        StrongSelf(weakSelf);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(selectedSong:)]) {
            [strongSelf.delegate selectedSong:musicModel];
        }
    }];
}

#pragma mark - DATASOURCE & DELEGATE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSKTVMusicListCell *cell = (RCSKTVMusicListCell *)[tableView dequeueReusableCellWithIdentifier:[RCSKTVMusicListCell identifier] forIndexPath:indexPath];
    [cell updateUIWithModel:self.presenter.dataModels[indexPath.row]];
    cell.delegate = self;
    return cell;
}
@end
