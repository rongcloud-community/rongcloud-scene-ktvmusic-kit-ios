//
//  RCSLyricCell.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricCell.h"
#import "RCSLyricLabel.h"
#import "RCSEnhancedLrcModel.h"

@interface RCSLyricCell ()

@property (nonatomic, strong) RCSLyricLabel *contentLabel;

@end

@implementation RCSLyricCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
}

- (void)setUpContent:(NSString *)content; {
    self.contentLabel.text = content;
}

- (void)isPlaying:(BOOL)isPlaying {
    UIFont *highlightFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    UIFont *normalFont = [UIFont systemFontOfSize:12];
    self.contentLabel.font = isPlaying ? highlightFont : normalFont;
    CGFloat lineWidth = [self calculateContentWidth:self.contentLabel.font content:self.contentLabel.text];
    if (self.contentView.width <= lineWidth) {
        CGFloat scale = self.contentView.width / lineWidth;
        if (isPlaying) {
            self.contentLabel.font = [UIFont systemFontOfSize:15*scale weight:UIFontWeightMedium];
        } else {
            self.contentLabel.font = [UIFont systemFontOfSize:11*scale];
        }
    }
    if ([self.sentence isKindOfClass:[RCSELrcSentenceModel class]]) {
        [self.contentLabel shouldLoadMask:isPlaying];
    } else {
        self.contentLabel.textColor = isPlaying ? RCSKTVMusicMainColor : [UIColor whiteColor];
    }
}

- (CGFloat)calculateContentWidth:(UIFont *)font content:(NSString *)content {
  NSDictionary *attrs = @{NSFontAttributeName:font};
  CGSize size = [content sizeWithAttributes:attrs];
  return ceilf(size.width);
}

- (void)updateTextWithCurrentTime:(CGFloat)currentTime {
    [self isPlaying:YES];
    if (![self.sentence isKindOfClass:[RCSELrcSentenceModel class]]) {
        return ;
    }
    
    CGFloat progress = [self getCurrentProgressWithTime:currentTime];
    self.contentLabel.progress = progress;
}

- (CGFloat)getCurrentProgressWithTime:(CGFloat)time {
    RCSELrcSentenceModel *model = (RCSELrcSentenceModel *)self.sentence;
    
    CGFloat fullTime = model.words.lastObject.endTime - model.words.firstObject.startTime;
    CGFloat currentTime = time - model.words.firstObject.startTime;
    
    return currentTime / fullTime;
}

- (RCSLyricLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [RCSLyricLabel new];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
    }
    return _contentLabel;
}


@end
