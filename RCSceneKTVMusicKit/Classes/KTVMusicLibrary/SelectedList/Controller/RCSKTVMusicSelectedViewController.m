//
// Created by xuefeng on 2022/7/8.
//

#import "RCSKTVMusicSelectedViewController.h"
#import "RCSKTVMusicSelectedCell.h"
#import "RCSKTVMusicSelectedPresenter.h"
#import "RCSKTVMusicSelectedDataProtocol.h"
#import "RCSKTVRoomModel.h"
#import <MJRefresh/MJRefresh.h>

@interface RCSKTVMusicSelectedViewController()<UITableViewDataSource, UITableViewDelegate, RCSKTVMusicSelectedCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) RCSKTVMusicSelectedPresenter *presenter;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *controlMicBtn;

/// 是否存在房间
@property (nonatomic, assign) BOOL hadCreateRoom;

@end

@implementation RCSKTVMusicSelectedViewController

- (instancetype)initWithRoomId:(NSString *)roomId
                 hadCreateRoom:(BOOL )hadCreateRoom
                 currentUserId:(NSString *)currentUserId
               currentUserName:(NSString *)currentUserName
           currentUserPortrait:(NSString *)currentUserPortrait {
    if (self = [super init]) {
        self.presenter.roomId = roomId;
        self.hadCreateRoom = hadCreateRoom;
        self.presenter.filter = hadCreateRoom ? 0 : 1;
        self.presenter.currentUserId = currentUserId;
        self.presenter.currentUserName = currentUserName;
        self.presenter.currentUserPortrait = currentUserPortrait;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
    WeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(weakSelf);
        [strongSelf fetchMusicListCompletionBlock:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchMusicListCompletionBlock:nil];
}

- (void)selectedSongWithArtistName:(NSString *)artistName
                           musicId:(NSString *)musicId
                         musicName:(NSString *)musicName
                   completionBlock:(void(^)(BOOL success))completionBlock {
    [self.presenter selectedSongWithArtistName:artistName
                                       musicId:musicId
                                     musicName:musicName
                               completionBlock:completionBlock];
}

- (void)setSolo:(BOOL)solo {
    _solo = solo;
    self.presenter.solo = solo ? 1 : 0;
}

- (void)setPlayingId:(NSString *)playingId {
    _playingId = playingId;
    self.presenter.playingMusicId = playingId;
}

/// 请求歌单数据
- (void)fetchMusicListCompletionBlock:(void(^)(NSDictionary *dataDic))completionBlock {
    WeakSelf(self);
    [self.presenter fetchKTVRoomSettingWithCompletionBlock:^(BOOL success, NSDictionary * _Nullable dataDic) {
        StrongSelf(weakSelf);
        [strongSelf updateUI];
        !completionBlock ?: completionBlock(dataDic);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(musicListUpdated:musicCount:)]) {
            [strongSelf.delegate musicListUpdated:dataDic musicCount:(int)self.presenter.dataModels.count];
        }
    }];
}

/// 切歌/删除歌曲
- (void)deleteSong:(id<RCSKTVRoomMusicProtocol>)model completionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.presenter deleteTheSong:model.songId completionBlock:^(BOOL success) {
        if (!success) {
            return ;
        }
        StrongSelf(weakSelf)
        [strongSelf fetchMusicListCompletionBlock:nil];
        !completionBlock ?: completionBlock(success);
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMusic:)]) {
            [self.delegate deleteMusic:model];
        }
    }];
}

/// 触发置顶歌曲接口
- (void)topSong:(id<RCSKTVRoomMusicProtocol>)model completionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.presenter pinTheSong:model.songId
               completionBlock:^(BOOL success) {
        !completionBlock ?: completionBlock(success);
        if (!success) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(topMusic:)]) {
            [self.delegate topMusic:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"置顶成功"];
        StrongSelf(weakSelf)
        [strongSelf fetchMusicListCompletionBlock:nil];
    }];
}

/// 置顶控麦
- (void)topTheMicControlWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.presenter pinTheSong:RCSKTVMusicControlMicSongId
               completionBlock:^(BOOL success) {
        !completionBlock ?: completionBlock(success);
        if (!success) {
            return;
        }
        StrongSelf(weakSelf)
        [strongSelf fetchMusicListCompletionBlock:nil];
    }];
}

#pragma mark - SETUPSUBVIEWS
- (void)setupViews {
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.trailing.leading.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)updateUI {
    [self.tableView.mj_header endRefreshing];
    self.emptyImageView.hidden = (self.presenter.dataModels.count != 0);
    [self.tableView reloadData];
    self.bottomView.hidden = !self.presenter.isHost;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.presenter.isHost ? 80 : 0);
    }];
    NSString *btnTitle = self.presenter.hasControlMic ? @"取消控麦" : @"控麦";
    [self.controlMicBtn setTitle:btnTitle forState:UIControlStateNormal];
    
}

#pragma mark - RCSKTVMusicSelectedCellDelegate

- (void)pinTheSong:(NSInteger)row {
    id<RCSKTVMusicSelectedDataProtocol>model = self.presenter.dataModels[row];
    id<RCSKTVRoomMusicProtocol> songModel = [self coverToRoomMusicWithSelectedData:model];
    if (model.pinPermission == 1 || !self.hadCreateRoom) { /// 如果是房主，直接置顶，调用置顶接口 或者没有创建语聊房，直接置顶
        [self topSong:songModel completionBlock:nil];
    } else if (model.pinPermission == 0) { /// 如果是其它人，告诉房间，申请歌曲置顶
        if (self.delegate && [self.delegate respondsToSelector:@selector(applyForTopMusic:)]) {
            [self.delegate applyForTopMusic:songModel];
        }
    }
}

- (void)deleteTheSong:(NSInteger)row {
    id<RCSKTVMusicSelectedDataProtocol>model = self.presenter.dataModels[row];
    BOOL isControlMic = [model.songId isEqualToString:RCSKTVMusicControlMicSongId];
    NSString *message = isControlMic ? @"是否删除控麦" : @"是否删除歌曲";
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        id<RCSKTVRoomMusicProtocol> songModel = [self coverToRoomMusicWithSelectedData:model];
        [self deleteSong:songModel completionBlock:^(BOOL success) {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:cancelAction];
    [controller addAction:sureAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)controlMic:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"控麦"]) { // 控麦
        if (self.delegate && [self.delegate respondsToSelector:@selector(controlMic)]) {
            [self.delegate controlMic];
        }
        return ;
    }

    /// 取消控麦
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:@"是否取消控麦"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        WeakSelf(self);
        [self.presenter deleteTheSong:RCSKTVMusicControlMicSongId completionBlock:^(BOOL success) {
            if (!success) {
                return ;
            }
            StrongSelf(weakSelf)
            [strongSelf fetchMusicListCompletionBlock:nil];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:cancelAction];
    [controller addAction:sureAction];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - private method
-(id<RCSKTVRoomMusicProtocol>)coverToRoomMusicWithSelectedData:(id<RCSKTVMusicSelectedDataProtocol>)model {
    id<RCSKTVRoomMusicProtocol> songModel = [RCSKTVRoomMusicModel new];
    songModel.userPortrait = model.userPortrait;
    songModel.artistName = model.artistName;
    songModel.solo = model.solo;
    songModel.musicName = model.musicName;
    songModel.songId = model.songId;
    songModel.roomId = model.roomId;
    songModel.userId = model.userId;
    songModel.musicId = model.musicId;
    return songModel;
}

#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[RCSKTVMusicSelectedCell class]
           forCellReuseIdentifier:[RCSKTVMusicSelectedCell identifier]];
        [_tableView addSubview:self.emptyImageView];
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
        self.emptyImageView.hidden = YES;
    }
    return _tableView;
}

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [UIImageView new];
        _emptyImageView.image = RCSKTVMusicImageNamed(@"list_empty");
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        label.textColor = [UIColor whiteColor];
        label.text = @"暂无已点歌曲";
        [_emptyImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.offset(-12);
        }];
    }
    return _emptyImageView;
}

- (RCSKTVMusicSelectedPresenter *)presenter {
    if (!_presenter) {
        _presenter = [RCSKTVMusicSelectedPresenter new];
    }
    return _presenter;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor rcs_colorWithHex:0xFFFFFF alpha:0.1];
        [_bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.top.offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _bottomView;
}

- (UIButton *)controlMicBtn {
    if (!_controlMicBtn) {
        _controlMicBtn = [UIButton new];
        _controlMicBtn.backgroundColor = [UIColor rcs_colorWithHex:0xD9D9D9 alpha:0.4];
        _controlMicBtn.layer.cornerRadius = 14.0;
        _controlMicBtn.layer.masksToBounds = YES;
        _controlMicBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_controlMicBtn setTitle:@"控麦" forState:UIControlStateNormal];
        [_controlMicBtn addTarget:self action:@selector(controlMic:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_controlMicBtn];
        [_controlMicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(28);
        }];
    }
    return _controlMicBtn;
}

#pragma mark - DATASOURCE & DELEGATE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSKTVMusicSelectedCell *cell = (RCSKTVMusicSelectedCell *)[tableView dequeueReusableCellWithIdentifier:[RCSKTVMusicSelectedCell identifier] forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateUIWithModel:self.presenter.dataModels[indexPath.row] row:indexPath.row];
    return cell;
}

@end
