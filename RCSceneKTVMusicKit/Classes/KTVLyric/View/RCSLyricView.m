//
//  RCSLyricView.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricView.h"
#import "RCSLyricReadyView.h"
#import "RCSLyricCell.h"
#import "RCSLyricParser.h"
#import "RCSEnhancedLrcModel.h"
#import "RCSSimpleLrcModel.h"
#import "RCSLyricParser.h"

@interface RCSLyricView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RCSLyricReadyView *readyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RCSLyricModel *lyric;
@property (nonatomic, assign) NSInteger currentPlayingRow;
@property (nonatomic, assign) BOOL showedReadyView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat currentTime;

@end

@implementation RCSLyricView
- (instancetype)init {
    if (self = [super init]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    
    [self addSubview:self.readyView];
    [self.readyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.top.mas_equalTo(self.readyView.mas_bottom);
        make.height.mas_equalTo(72);
    }];
}

#pragma mark - public method
- (void)configCurrentSongWithURL:(NSURL *)lyricURL {
    NSError *error = nil;
    RCSLyricModel *model = nil;
    NSData *data = [NSData dataWithContentsOfURL:lyricURL];
    model = [[RCSHFKrcParser parser] lyricObjectForData:data error:&error];
    if (!model) {
        model = [[RCSKrcParser parser] lyricObjectForData:data error:&error];
    }
    if (!model) {
        model = [[RCSEnhancedLrcParser parser] lyricObjectForData:data error:&error];
    }
    if (!model) {
        model = [[RCSSimpleLrcParser parser] lyricObjectForData:data error:&error];
    }
    if (!model) {
        model = [[RCSLyricParser parser] lyricObjectForData:data error:&error];
    }
    
    self.lyric = model;
    [self resetLyric];
    [self.tableView reloadData];
}

- (BOOL)configCurrentSongWithURL:(NSURL *)lyricURL lyricParser:(RCSLyricParser *)parser {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:lyricURL];
    self.lyric = [parser lyricObjectForData:data error:&error];
    [self resetLyric];
    [self.tableView reloadData];
    return (error == nil);
}

- (void)updateCurrentPlayingTime:(CGFloat)currentTime {
    self.currentTime = currentTime;
    [self resetDisplayLink];
}

- (void)stopAnimation:(BOOL)stop {
    self.displayLink.paused = stop;
}

#pragma mark - private method
- (void)updateLyrics:(CGFloat)currentTime {
    
    if (self.lyric.type == RCSLyricModelTypeStatic) {
        return ;
    }
    
    NSInteger count = self.lyric.lines.count;
    if (self.currentPlayingRow >= count) {
        return ;
    }
    
    RCSSimpleLrcModel *lyric = (RCSSimpleLrcModel *)self.lyric;
    [self updateReadyView:lyric currentTime:currentTime];
    
    for (int i = 0; i < count; i++) {
        RCSSentenceModel *sentence = lyric.sentences[i];
        if (sentence.startTime >= currentTime) {
            NSInteger currentRow = (i > 0) ? (i - 1) : 0;
            [self setCurrentPlayingRow:currentRow currentTime:currentTime];
            break;
        }
        if ((lyric.sentences.lastObject.startTime < currentTime) && (i == count - 1)) {
            [self setCurrentPlayingRow:i currentTime:currentTime];
        }
    }
}

- (void)updateReadyView:(RCSSimpleLrcModel *)lyric currentTime:(CGFloat)currentTime {
    if (lyric.sentences.firstObject.startTime < 5) {
        self.showedReadyView = YES;
    }
    
    if (lyric.sentences.firstObject.startTime - currentTime < 5 && !self.showedReadyView) {
        self.showedReadyView = YES;
        [self.readyView show];
    }
}

- (void)setCurrentPlayingRow:(NSInteger)currentRow currentTime:(CGFloat)currentTime {
    if (self.currentPlayingRow == currentRow) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
        RCSLyricCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell updateTextWithCurrentTime:currentTime];
        return;
    }
    
    self.currentPlayingRow = currentRow;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)resetLyric {
    self.currentPlayingRow = 0;
    self.showedReadyView = NO;
    self.currentTime = 0;
    [self stopAnimation:YES];
}

- (void)resetDisplayLink {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    self.displayLink.paused = NO;
}

- (void)rotation:(CADisplayLink *)displayLink {
    self.currentTime += displayLink.duration;
    [self updateLyrics:self.currentTime];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RCSLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RCSLyricCell class])];
    [cell setUpContent:self.lyric.lines[indexPath.row]];
    if (self.lyric.type == RCSLyricModelTypeEnhancedLrc) {
        RCSEnhancedLrcModel *lyric = (RCSEnhancedLrcModel *)self.lyric;
        cell.sentence = lyric.sentences[self.currentPlayingRow];
        [cell isPlaying:indexPath.row == self.currentPlayingRow];
    } if (self.lyric.type == RCSLyricModelTypeSimpleLrc) {
        [cell isPlaying:indexPath.row == self.currentPlayingRow];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyric.lines.count;
}

#pragma mark - lazy load
- (RCSLyricReadyView *)readyView {
    if (!_readyView) {
        _readyView = [RCSLyricReadyView new];
        _readyView.hidden = YES;
    }
    return _readyView;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[RCSLyricCell class] forCellReuseIdentifier:NSStringFromClass([RCSLyricCell class])];
    }
    return _tableView;
}

@end
