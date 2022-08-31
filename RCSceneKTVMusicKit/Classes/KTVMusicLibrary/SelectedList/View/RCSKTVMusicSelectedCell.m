//
//  RCSKTVMusicSelectedCell.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/11.
//

#import "RCSKTVMusicSelectedCell.h"
#import <SDWebImage/SDWebImage.h>

@interface RCSKTVMusicSelectedCell ()

@property (nonatomic, strong) UIImageView *playingView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UILabel *soloTipsLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *pinBtn;
@property (nonatomic, assign) NSInteger row;

@end

@implementation RCSKTVMusicSelectedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)updateUIWithModel:(id<RCSKTVMusicSelectedDataProtocol>)model row:(NSInteger)row {
    self.row = row;
    
    self.playingView.hidden = !model.isPlaying;
    self.indexLabel.hidden = model.isPlaying;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)row+1];
    if (model.userPortrait.length != 0) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.userPortrait]];
    }
    self.nameLabel.text = model.musicName;
    self.singerLabel.text = model.artistName;
    self.deleteBtn.hidden = !model.allowDelete;
    self.pinBtn.hidden = (model.pinPermission == -1);
    self.soloTipsLabel.hidden = model.isMicControl;
    
    if (model.solo == 1) {
        self.soloTipsLabel.text = @"独唱";
        self.soloTipsLabel.backgroundColor = RCSKTVMusicMainColor;
    } else if (model.solo == 0) {
        self.soloTipsLabel.text = @"合唱";
        self.soloTipsLabel.backgroundColor = [UIColor rcs_colorWithHex:0xFB6710];
    }
    
    self.pinBtn.hidden = (row == 0 || row == 1);
}

#pragma mark SETUPVIEWS

- (void)setupViews {
    [self.contentView addSubview:self.playingView];
    [self.playingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(17, 18));
    }];
    
    [self.contentView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playingView);
    }];
    
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.playingView.mas_trailing).offset(12);
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
    
    [self.contentView addSubview:self.soloTipsLabel];
    [self.soloTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(6);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(35, 16));
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.contentView addSubview:self.pinBtn];
    [self.pinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.deleteBtn.mas_leading).offset(-24);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

}

#pragma mark - PRIVATE METHOD

- (void)pinIt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pinTheSong:)]) {
        [self.delegate pinTheSong:self.row];
    }
}

- (void)deleteIt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTheSong:)]) {
        [self.delegate deleteTheSong:self.row];
    }
}


#pragma mark - GETTER
- (UIImageView *)playingView {
    if (!_playingView) {
        _playingView = [UIImageView new];
        _playingView.contentMode = UIViewContentModeScaleAspectFill;
        _playingView.image = RCSKTVMusicImageNamed(@"playing_icon");
    }
    return _playingView;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [UILabel new];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.image = RCSKTVMusicImageNamed(@"default_avatar");
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

- (UILabel *)soloTipsLabel {
    if (!_soloTipsLabel) {
        _soloTipsLabel = [UILabel new];
        _soloTipsLabel.font = [UIFont systemFontOfSize:10];
        _soloTipsLabel.textColor = [UIColor whiteColor];
        _soloTipsLabel.text = @"独唱";
        _soloTipsLabel.layer.masksToBounds = YES;
        _soloTipsLabel.layer.cornerRadius = 2;
        _soloTipsLabel.backgroundColor = RCSKTVMusicMainColor;
        _soloTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _soloTipsLabel;
}

- (UIButton *)pinBtn {
    if (!_pinBtn) {
        _pinBtn = [UIButton new];
        [_pinBtn setImage:RCSKTVMusicImageNamed(@"pin_icon")
                 forState:UIControlStateNormal];
        [_pinBtn addTarget:self action:@selector(pinIt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pinBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:RCSKTVMusicImageNamed(@"delete_icon")
                    forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteIt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

#pragma mark - CELL REUSE IDENTIFIER

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

@end
