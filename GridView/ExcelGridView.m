//
//  ExcelGridView.m
//  GridView
//
//  Created by 胡金友 on 2018/4/3.
//

#import "ExcelGridView.h"
#import "ExcelGridItemCell.h"
#import "UIView+__ExcelGrid.h"

static NSString *__GridViewDefaultItemCellIdentifier__ = @"com.jyhu.__GridViewDefaultItemCellIdentifier__";
static NSString *__GridViewDefaultHoriItemCellIdentifier__ = @"com.jyhu.__GridViewDefaultHoriItemCellIdentifier__";



@interface ExcelGridView () <
ExcelGridFrameDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

/**
 01 角标视图，一般不会滚动
 */
@property (nonatomic, strong) UIView *grid_cornerView;

/**
 02 横向的标题视图，必须是UIScrollView或者其子类，可用于实现内容视图滚动时的联动
 */
@property (nonatomic, strong) UIScrollView *grid_horizontalHeaderScrollView;

/**
 03 纵向的标题视图，必须是UIScrollView或者其子类，可用于实现内容视图滚动时的联动
 */
@property (nonatomic, strong) UITableView *grid_verticalHeaderScrollView;

/**
 04 展示的内容视图，必须是UIScrollView或者其子类，用于展示可滚动的多行列内容
 */
@property (nonatomic, strong) UIScrollView *grid_contentScrollView;

@end


@implementation ExcelGridView


- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.verticalHeaderScrollView = self.grid_verticalHeaderScrollView;
    self.gridFrameDelegate = self;
    
    _rowHeight = 44;
    _contentItemWidth = 90;
    _groupHeaderHeight = 0;
    _numberOfLines = 1;
}

- (void)reloadData {
    if (self.grid_verticalHeaderScrollView) {
        [self.grid_verticalHeaderScrollView reloadData];
    }
    if (self.grid_contentScrollView) {
        if ([self.grid_contentScrollView isKindOfClass:[UITableView class]]) {
            [(UITableView *)self.grid_contentScrollView reloadData];
        }
        if ([self.grid_contentScrollView isKindOfClass:[UICollectionView class]]) {
            [(UICollectionView *)self.grid_contentScrollView reloadData];
        }
    }
    
    if (self.grid_horizontalHeaderScrollView && [self.grid_horizontalHeaderScrollView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)self.grid_horizontalHeaderScrollView reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reloadData];
}

#pragma mark - horizontal header custom view sources

- (void)setupHorizontalHeaderViews {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfLinesInGridView:)]) {
        [self.grid_horizontalHeaderScrollView grid_removeAllSubViews];
        
        if ([self.delegate respondsToSelector:@selector(gridView:viewForHorizontalHeaderAtIndex:)]) {
            CGFloat originx = 0;
            
            self.grid_horizontalHeaderScrollView.contentSize = CGSizeMake(self.contentWidth, self.horizontalHeaderHeight);
            
            for (NSInteger i = 0; i < [self.delegate numberOfLinesInGridView:self]; i ++) {
                UIView *view = [self.delegate gridView:self viewForHorizontalHeaderAtIndex:i];
                if (view) {
                    CGFloat width = self.contentItemWidth;
                    if ([self.delegate respondsToSelector:@selector(gridView:widthForLineWithIndex:)]) {
                        width = [self.delegate gridView:self widthForLineWithIndex:i];
                    }
                    
                    view.frame = CGRectMake(originx, 0, width, self.horizontalHeaderHeight);
                    originx += width;
                    [self.grid_horizontalHeaderScrollView addSubview:view];
                }
            }
        }
    }
}

#pragma mark - table view delegate datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfSectionsInGridView:)]) {
        return [self.delegate numberOfSectionsInGridView:self];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:numberOfRowsInSection:)]) {
        return [self.delegate gridView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        if ([tableView isEqual:self.grid_verticalHeaderScrollView]) {
            if ([self.delegate respondsToSelector:@selector(gridView:verticalHeaderCell:atIndexPath:)]) {
                static NSString *reusefulDefaultTitleIdentifier = @"auu.grid.reusefulDefaultTitleIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusefulDefaultTitleIdentifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusefulDefaultTitleIdentifier];
                }
                [self.delegate gridView:self verticalHeaderCell:cell atIndexPath:indexPath];
                
                return cell;
            }
            
            if ([self.delegate respondsToSelector:@selector(gridView:titleCellOfVerticalHeaderAtIndexPath:)]) {
                return [self.delegate gridView:self titleCellOfVerticalHeaderAtIndexPath:indexPath];
            }
            
            NSAssert2(0, @"纵向标题的设置必须实现`%@`和`%@`方法之一",
                      NSStringFromSelector(@selector(gridView:verticalHeaderCell:atIndexPath:)),
                      NSStringFromSelector(@selector(gridView:titleCellOfVerticalHeaderAtIndexPath:)));
            
        } else if ([tableView isEqual:self.grid_contentScrollView]) {
            
            NSAssert1([self.delegate respondsToSelector:@selector(gridView:contentCellAtIndexPath:)],
                      @"ExcelGridVisualTypeTableView类型的内容视图，必须实现`%@`方法",
                      NSStringFromSelector(@selector(gridView:contentCellAtIndexPath:)));
            
            return [self.delegate gridView:self contentCellAtIndexPath:indexPath];
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:heightForRow:inSection:)]) {
        return [self.delegate gridView:self heightForRow:indexPath.row inSection:indexPath.section];
    }
    
    return self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:heightForHeaderInSection:)]) {
        return [self.delegate gridView:self heightForHeaderInSection:section];
    }
    
    if (self.groupHeaderHeight == 0) {
        return kGRID_DOUBLE_ZERO;
    }
    
    return self.groupHeaderHeight;
}

#pragma mark - collection view delegate datasource

// 分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.delegate) {
        // 如果是内容的Collection，则需要判断代理
        if ([collectionView isEqual:self.grid_contentScrollView] &&
            [self.delegate respondsToSelector:@selector(numberOfSectionsInGridView:)]) {
            return [self.delegate numberOfSectionsInGridView:self];
        }
    }
    
    // 横向标题只有一个分组
    return 1;
}

// 每个分组有多少的item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSInteger lines = self.numberOfLines;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(numberOfLinesInGridView:)]) {
            lines = [self.delegate numberOfLinesInGridView:self];
        }
        
        // 如果是横向标题的collection，则直接返回
        if ([collectionView isEqual:self.grid_horizontalHeaderScrollView]) {
            return lines;
        }
        
        if ([self.delegate respondsToSelector:@selector(gridView:numberOfRowsInSection:)]) {
            rows = [self.delegate gridView:self numberOfRowsInSection:section];
        }
    }
    
    return rows * lines;
}

// 设置item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        if ([collectionView isEqual:self.grid_contentScrollView]) {
            if ([self.delegate respondsToSelector:@selector(gridView:contentItemCell:atIndexPath:)]) {
                ExcelGridItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:__GridViewDefaultItemCellIdentifier__ forIndexPath:indexPath];
                [self.delegate gridView:self contentItemCell:cell atIndexPath:indexPath];
                return cell;
            }
            
            if ([self.delegate respondsToSelector:@selector(gridView:contentItemCellAtIndexPath:)]) {
                return [self.delegate gridView:self contentItemCellAtIndexPath:indexPath];
            }
            
            NSAssert2(0, @"Collection类型的内容区必须实现`%@`与`%@`两个代理方法中的其中一个",
                      NSStringFromSelector(@selector(gridView:contentItemCell:atIndexPath:)),
                      NSStringFromSelector(@selector(gridView:contentItemCellAtIndexPath:)));
            
            return nil;
        } else {
            if (self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeDefault) {
                ExcelGridItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:__GridViewDefaultHoriItemCellIdentifier__ forIndexPath:indexPath];
                if ([self.delegate respondsToSelector:@selector(gridView:horizontalHeaderCell:atIndex:)]) {
                    [self.delegate gridView:self horizontalHeaderCell:cell atIndex:indexPath.row];
                } else {
                    cell.textLabel.text = @"--";
                }
                
                return cell;
            }
            
            if (self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeCustomerCell) {
                NSAssert1([self.delegate respondsToSelector:@selector(gridView:cellForHorizontalHeaderAtIndex:)],
                          @"ExcelGridHorizontalHeaderTypeCustomerCell类型的横向标题必须实现`%@`方法",
                          NSStringFromSelector(@selector(gridView:cellForHorizontalHeaderAtIndex:)));
                
                return [self.delegate gridView:self cellForHorizontalHeaderAtIndex:indexPath.row];
            }
        }
    }
    return nil;
}

// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.contentItemWidth;
    CGFloat height = self.rowHeight;
    NSInteger lineCount = self.numberOfLines;
    
    if (self.delegate) {
        // 获取内容区的列宽
        if ([self.delegate respondsToSelector:@selector(gridView:widthForLineWithIndex:)]) {
            width = [self.delegate gridView:self widthForLineWithIndex:(indexPath.row % lineCount)];
        }
        
        if ([collectionView isEqual:self.grid_horizontalHeaderScrollView]) {
            // 设置横向标题的大小
            return CGSizeMake(width, self.horizontalHeaderHeight);
        }
        
        // 获取内容区的列数
        if ([self.delegate respondsToSelector:@selector(numberOfLinesInGridView:)]) {
            lineCount = [self.delegate numberOfLinesInGridView:self] ?: 1;
        }
        
        // 获取每行内容的高度
        if ([self.delegate respondsToSelector:@selector(gridView:heightForRow:inSection:)]) {
            height = [self.delegate gridView:self heightForRow:((NSInteger)(indexPath.row / lineCount)) inSection:indexPath.section];
        }
    }
    
    return CGSizeMake(width, height);
}

// cell间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 组间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// section header 设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGFloat headerHeight = self.groupHeaderHeight;
    if ([collectionView isEqual:self.grid_contentScrollView]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:heightForHeaderInSection:)]) {
            headerHeight = [self.delegate gridView:self heightForHeaderInSection:section];
        }
        
        if (headerHeight == 0) {
            return CGSizeZero;
        }
        
        return CGSizeMake(collectionView.grid_width, headerHeight);
    }
    
    return CGSizeZero;
}

// cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked collection cell");
}

#pragma mark - getter setter

- (void)setGridVisualType:(ExcelGridVisualType)gridVisualType {
    _gridVisualType = gridVisualType;
    
    if (self.contentScrollView && self.grid_contentScrollView &&
        [self.contentScrollView isEqual:self.grid_contentScrollView]) {
        self.contentScrollView = nil;
    }
    
    if (self.grid_contentScrollView) {
        if ((self.gridVisualType == ExcelGridVisualTypeTableView &&
             ![self.grid_contentScrollView isKindOfClass:[UITableView class]]) ||
            (self.gridVisualType == ExcelGridVisualTypeCollectionView &&
             ![self.grid_contentScrollView isKindOfClass:[UICollectionView class]])) {
                self.grid_contentScrollView = nil;
            }
    }
    
    if (!self.grid_contentScrollView) {
        if (self.gridVisualType == ExcelGridVisualTypeTableView) {
            // 添加TableView
            UITableView *tempTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
            tempTable.dataSource = self;
            tempTable.backgroundColor = [UIColor clearColor];
            tempTable.sectionHeaderHeight = 0;
            tempTable.sectionFooterHeight = 0;
            tempTable.estimatedSectionFooterHeight = 0;
            tempTable.estimatedSectionHeaderHeight = 0;
            
            self.grid_contentScrollView = tempTable;
        } else if (self.gridVisualType == ExcelGridVisualTypeCollectionView) {
            // 添加CollectionView
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            UICollectionView *tempCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            tempCollection.dataSource = self;
            tempCollection.backgroundColor = [UIColor clearColor];
            [tempCollection registerClass:[ExcelGridItemCell class] forCellWithReuseIdentifier:__GridViewDefaultItemCellIdentifier__];
            
            self.grid_contentScrollView = tempCollection;
        }
    }
    
    self.contentScrollView = self.grid_contentScrollView;
}

- (UITableView *)grid_verticalHeaderScrollView {
    if (!_grid_verticalHeaderScrollView) {
        _grid_verticalHeaderScrollView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _grid_verticalHeaderScrollView.dataSource = self;
        _grid_verticalHeaderScrollView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGRID_DOUBLE_ZERO, kGRID_DOUBLE_ZERO)];
        _grid_verticalHeaderScrollView.backgroundColor = [UIColor clearColor];
        _grid_verticalHeaderScrollView.sectionHeaderHeight = 0;
        _grid_verticalHeaderScrollView.sectionFooterHeight = 0;
        _grid_verticalHeaderScrollView.rowHeight = 0;
        _grid_verticalHeaderScrollView.estimatedRowHeight = 0;
        _grid_verticalHeaderScrollView.estimatedSectionFooterHeight = 0;
        _grid_verticalHeaderScrollView.estimatedSectionHeaderHeight = 0;
        _grid_verticalHeaderScrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_grid_verticalHeaderScrollView reloadData];
    }
    return _grid_verticalHeaderScrollView;
}

- (void)setHorizontalHeaderType:(ExcelGridHorizontalHeaderType)horizontalHeaderType {
    _horizontalHeaderType = horizontalHeaderType;
    
    if (horizontalHeaderType == ExcelGridHorizontalHeaderTypeDefault ||
        self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeCustomerCell) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        [collectionView registerClass:[ExcelGridItemCell class] forCellWithReuseIdentifier:__GridViewDefaultHoriItemCellIdentifier__];
        self.grid_horizontalHeaderScrollView = collectionView;
    } else if (self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeCustomerView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.backgroundColor = [UIColor clearColor];
        self.grid_horizontalHeaderScrollView = scrollView;
        [self setupHorizontalHeaderViews];
    }
    
    self.horizontalHeaderScrollView = self.grid_horizontalHeaderScrollView;
}

- (void)setDelegate:(id<ExcelGridViewDelegate>)delegate {
    _delegate = delegate;
}

@end
