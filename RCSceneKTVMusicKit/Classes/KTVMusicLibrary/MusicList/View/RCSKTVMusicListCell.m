//
// Created by xuefeng on 2022/7/8.
//

#import "RCSKTVMusicListCell.h"
#import <SDWebImage/SDWebImage.h>

@interface RCSKTVMusicListCell()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UIButton *songButton;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) id<RCSKTVSongProtocol> model;

@end

@implementation RCSKTVMusicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

#pragma mark - PUBLIC METHOD
- (void)updateUIWithModel:(id<RCSKTVSongProtocol>)model {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl]];
    self.nameLabel.text = model.musicName;
    self.singerLabel.text = model.artistName;
    self.model = model;
}

- (void)updateLoadingProgress:(int)progress {
    self.progressLabel.text = [NSString stringWithFormat:@"正在下载···%d%%", progress];
    if (progress > 99) {
        self.songButton.hidden = NO;
        self.progressLabel.hidden = YES;
    } else {
        self.songButton.hidden = YES;
        self.progressLabel.hidden = NO;
    }
}

#pragma mark - SETUPVIEWS

- (void)setupViews {
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_trailing).offset(6);
        make.top.equalTo(self.avatarView.mas_top).offset(6);
    }];

    [self.contentView addSubview:self.singerLabel];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_trailing).offset(6);
        make.bottom.equalTo(self.avatarView.mas_bottom).offset(-10);
    }];

    [self.contentView addSubview:self.songButton];
    [self.songButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(47, 24));
    }];
    
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-12);
    }];
}

#pragma mark - PRIVATE METHOD

- (void)orderIt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(musicListCell:selectedMusic:)]) {
        [self.delegate musicListCell:self selectedMusic:self.model];
    }
}

#pragma mark - GETTER

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.backgroundColor = RCSKTVMusicMainColor;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 10;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)singerLabel {
    if (!_singerLabel) {
        _singerLabel = [[UILabel alloc] init];
        _singerLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _singerLabel.textColor = [UIColor whiteColor];
    }
    return _singerLabel;
}

- (UIButton *)songButton {
    if (!_songButton) {
        _songButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _songButton.backgroundColor = RCSKTVMusicMainColor;
        _songButton.layer.masksToBounds = YES;
        _songButton.layer.cornerRadius = 12;
        _songButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_songButton setTitle:@"点歌" forState:UIControlStateNormal];
        [_songButton addTarget:self action:@selector(orderIt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _songButton;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.hidden = YES;
        _progressLabel.text = @"正在下载···0%";
    }
    return _progressLabel;
}
#pragma mark - CELL REUSE IDENTIFIER

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}
@end
