//
// Created by xuefeng on 2022/7/7.
//

#import "RCSKTVMusicGroupCategoryView.h"

@interface RCSKTVMusicGroupCategoryCell: UICollectionViewCell
@property (class, nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) id<RCSKTVMusicGroupCategoryProtocol> item;
@end

@implementation RCSKTVMusicGroupCategoryCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
    }];

    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(27, 2));
        make.bottom.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
}

#pragma mark  - SETTER

- (void)setItem:(id<RCSKTVMusicGroupCategoryProtocol>)item {
    _item = item;
    self.titleLabel.text = item.name;
    self.indicatorView.hidden = !item.selected;
    self.titleLabel.textColor = item.selected ? RCSKTVMusicMainColor : [UIColor whiteColor];
}

#pragma mark - GETTER

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.hidden = YES;
        _indicatorView.backgroundColor = [UIColor rcs_colorWithHex:0xEF499A];
    }
    return _indicatorView;
}

+ (NSString *)identifier {
    return @"RCSKTVMusicGroupCategoryCellIdentifier";
}

@end

@interface RCSKTVMusicGroupCategoryView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *categoryView;
@end

@implementation RCSKTVMusicGroupCategoryView

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        [self setupSubviews];
    }
    return self;
}

#pragma mark  - PRIVATE METHOD

- (void)toggleCategory:(NSIndexPath *)indexPath {
    //清除上一个选中状态
    for (int i = 0; i < self.items.count; ++i) {
        id<RCSKTVMusicGroupCategoryProtocol> item = self.items[i];
        if (item.selected) {
            item.selected = NO;
            break;
        }
    }
    //重新设置选中状态
    id<RCSKTVMusicGroupCategoryProtocol> item = self.items[indexPath.row];
    item.selected = YES;

    //更新列表
    [self.categoryView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(toggleCategoryIndex:)]) {
        [self.delegate toggleCategoryIndex:indexPath.row];
    }
}

#pragma mark SETUPVIEWS

- (void)setupSubviews {
    [self addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-4);
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
    }];
}

#pragma mark - SETTER

- (void)setItems:(NSArray<id<RCSKTVMusicGroupCategoryProtocol>> *)items {
    _items = items;
    if (items.count > 0) {
        [items firstObject].selected = YES;
    }
    [self.categoryView reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self toggleCategory:indexPath];
}

#pragma mark - GETTER

- (UICollectionView *)categoryView {
    if (_categoryView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 24;
        layout.minimumInteritemSpacing = 24;
        layout.estimatedItemSize = CGSizeMake(60, 30);
        _categoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _categoryView.delegate = self;
        _categoryView.dataSource = self;
        _categoryView.showsHorizontalScrollIndicator = NO;
        _categoryView.backgroundColor = [UIColor clearColor];
        [_categoryView registerClass:[RCSKTVMusicGroupCategoryCell class] forCellWithReuseIdentifier:RCSKTVMusicGroupCategoryCell.identifier];
    }
    return _categoryView;
}

#pragma mark - DELEGATE & DATASOURCE
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items ? self.items.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSKTVMusicGroupCategoryCell *cell = (RCSKTVMusicGroupCategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RCSKTVMusicGroupCategoryCell.identifier forIndexPath:indexPath];
    id<RCSKTVMusicGroupCategoryProtocol> item = self.items[indexPath.row];
    cell.titleLabel.text = @"haha";
    cell.item = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self toggleCategory:indexPath];
}

@end
