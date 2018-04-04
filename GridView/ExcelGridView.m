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

@property (nonatomic, assign, readwrite) ExcelGridVisualType visualType;
@property (nonatomic, strong) UILabel *cornerTitleLabel;

@property (nonatomic, strong) NSMutableSet *collectionContentIdentifiers;
@property (nonatomic, assign, readwrite) ExcelGridHorizontalHeaderType horizontalHeaderType;
@property (nonatomic, weak, readwrite) id <ExcelGridViewDelegate> delegate;

@end


@implementation ExcelGridView


- (instancetype)init {
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return nil;
}

- (instancetype)initWithVisualType:(ExcelGridVisualType)visualType delegate:(id<ExcelGridViewDelegate>)delegate {
    return [self initWithFrame:CGRectZero visualType:visualType delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame visualType:(ExcelGridVisualType)visualType delegate:(id<ExcelGridViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.visualType = visualType;
        self.delegate = delegate;
        self.horizontalHeaderType = ExcelGridHorizontalHeaderTypeNone;
        self.gridFrameDelegate = self;
        
        [self reloadFrame];
    }
    return self;
}

- (void)reloadFrame {
    if (self.visualType == ExcelGridVisualTypeTableView) {
        // 添加TableView
        UITableView *tempTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        tempTable.dataSource = self;
        tempTable.backgroundColor = [UIColor whiteColor];
        tempTable.sectionHeaderHeight = 0;
        tempTable.sectionFooterHeight = 0;
        tempTable.estimatedSectionFooterHeight = 0;
        tempTable.estimatedSectionHeaderHeight = 0;
        
        self.grid_contentScrollView = tempTable;
    } else {
        // 添加CollectionView
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *tempCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        tempCollection.dataSource = self;
        tempCollection.backgroundColor = [UIColor whiteColor];
        [tempCollection registerClass:[ExcelGridItemCell class] forCellWithReuseIdentifier:__GridViewDefaultItemCellIdentifier__];
        
        self.grid_contentScrollView = tempCollection;
    }
    
    if ([self.delegate respondsToSelector:@selector(horizontalHeaderTypeOfGridView:)]) {
        self.horizontalHeaderType = [self.delegate horizontalHeaderTypeOfGridView:self];
    }
    
    self.contentScrollView = self.grid_contentScrollView;
    self.verticalHeaderScrollView = self.grid_verticalHeaderScrollView;
    
    if (self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeDefault ||
        self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeCustomerCell) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        [collectionView registerClass:[ExcelGridItemCell class] forCellWithReuseIdentifier:__GridViewDefaultHoriItemCellIdentifier__];
        self.grid_horizontalHeaderScrollView = collectionView;
    } else if (self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeCustomerView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.grid_horizontalHeaderScrollView = scrollView;
        [self setupHorizontalHeaderViews];
    } else if (self.horizontalHeaderType == ExcelGridHorizontalHeaderTypeManual) {
        if ([self.delegate respondsToSelector:@selector(horizontalHeaderOfGridView:)]) {
            self.grid_horizontalHeaderScrollView = [self.delegate horizontalHeaderOfGridView:self];
        } else {
            NSLog(@"在你设置了GridHorizontalHeaderTypeManual类型后最好实现horizontalHeaderOfGridView:这个协议方法，否则上面会有空缺");
        }
    }
    self.horizontalHeaderScrollView = self.grid_horizontalHeaderScrollView;
    
    if ([self.delegate respondsToSelector:@selector(cornerViewInGridView:)]) {
        self.cornerView = [self.delegate cornerViewInGridView:self];
    } else if ([self.delegate respondsToSelector:@selector(gridView:titleOfCornerLabel:)]) {
        [self.delegate gridView:self titleOfCornerLabel:self.cornerTitleLabel];
        self.cornerView = self.cornerTitleLabel;
    }
}

#pragma mark - horizontal header custom view sources

- (void)setupHorizontalHeaderViews {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfLinesInGridView:)]) {
        if ([self.delegate respondsToSelector:@selector(gridView:viewForHorizontalHeaderAtIndex:)]) {
            CGFloat height = 45;
            CGFloat originx = 0;
            if ([self.delegate respondsToSelector:@selector(heightForHorizontalHeaderInGridFrame:)]) {
                height = [self.delegate heightForHorizontalHeaderInGridFrame:self];
            }
            if ([self.delegate respondsToSelector:@selector(contentWidthInGridFrame:)]) {
                self.grid_horizontalHeaderScrollView.contentSize = CGSizeMake([self.delegate contentWidthInGridFrame:self], height);
            }
            
            for (NSInteger i = 0; i < [self.delegate numberOfLinesInGridView:self]; i ++) {
                UIView *view = [self.delegate gridView:self viewForHorizontalHeaderAtIndex:i];
                if (view) {
                    CGFloat width = 72;
                    if ([self.delegate respondsToSelector:@selector(gridView:widthForLineWithIndex:)]) {
                        width = [self.delegate gridView:self widthForLineWithIndex:i];
                    }
                    
                    view.frame = CGRectMake(originx, 0, width, height);
                    originx += width;
                    [self.grid_horizontalHeaderScrollView addSubview:view];
                }
            }
        } else {
            
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
            
            return nil;
        } else {
            if ([self.delegate respondsToSelector:@selector(gridView:contentCellAtIndexPath:)]) {
                return [self.delegate gridView:self contentCellAtIndexPath:indexPath];
            }
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:heightForRow:inSection:)]) {
        return [self.delegate gridView:self heightForRow:indexPath.row inSection:indexPath.section];
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:heightForHeaderInSection:)]) {
        return [self.delegate gridView:self heightForHeaderInSection:section];
    }
    
    return 10e-10;
}

#pragma mark - collection view delegate datasource

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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSInteger lines = 0;
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
            
            return nil;
        } else {
            if ([self.delegate respondsToSelector:@selector(gridView:horizontalHeaderCell:atIndex:)]) {
                ExcelGridItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:__GridViewDefaultHoriItemCellIdentifier__ forIndexPath:indexPath];
                [self.delegate gridView:self horizontalHeaderCell:cell atIndex:indexPath.row];
                
                return cell;
            } else if ([self.delegate respondsToSelector:@selector(gridView:cellForHorizontalHeaderAtIndex:)]) {
                if (!self.horizontalHeaderScrollView) {
                    self.horizontalHeaderScrollView = self.grid_horizontalHeaderScrollView;
                }
                return [self.delegate gridView:self cellForHorizontalHeaderAtIndex:indexPath.row];
            }
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 60;
    CGFloat height = 44;
    NSInteger lineCount = 1;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(gridView:widthForLineWithIndex:)]) {
            width = [self.delegate gridView:self widthForLineWithIndex:(indexPath.row % lineCount)];
        }
        
        if ([collectionView isEqual:self.grid_horizontalHeaderScrollView]) {
            if ([self.delegate respondsToSelector:@selector(heightForHorizontalHeaderInGridFrame:)]) {
                height = [self.delegate heightForHorizontalHeaderInGridFrame:self];
            }
            
            return CGSizeMake(width, height);
        }
        
        
        if ([self.delegate respondsToSelector:@selector(numberOfLinesInGridView:)]) {
            lineCount = [self.delegate numberOfLinesInGridView:self] ?: 1;
        }
        
        if ([self.delegate respondsToSelector:@selector(gridView:heightForRow:inSection:)]) {
            height = [self.delegate gridView:self heightForRow:((NSInteger)(indexPath.row / lineCount)) inSection:indexPath.section];
        }
    }
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([collectionView isEqual:self.grid_contentScrollView]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:heightForHeaderInSection:)]) {
            return CGSizeMake(collectionView.grid_width, [self.delegate gridView:self heightForHeaderInSection:section]);
        }
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked collection cell");
}

#pragma mark - GridFrameDelegate

- (CGFloat)widthForVerticalHeaderInGridFrame:(ExcelGridFrame *)gridFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(widthForVerticalHeaderInGridFrame:)]) {
        return [self.delegate widthForVerticalHeaderInGridFrame:self];
    }
    
    return 120;
}

- (CGFloat)heightForHorizontalHeaderInGridFrame:(ExcelGridFrame *)gridFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForHorizontalHeaderInGridFrame:)]) {
        return [self.delegate heightForHorizontalHeaderInGridFrame:self];
    }
    
    return 45;
}

- (CGFloat)contentWidthInGridFrame:(ExcelGridFrame *)gridFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentWidthInGridFrame:)]) {
        return [self.delegate contentWidthInGridFrame:self];
    }
    
    return self.grid_width;
}

#pragma mark - getter setter

- (UITableView *)grid_verticalHeaderScrollView {
    if (!_grid_verticalHeaderScrollView) {
        _grid_verticalHeaderScrollView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _grid_verticalHeaderScrollView.dataSource = self;
        _grid_verticalHeaderScrollView.backgroundColor = [UIColor whiteColor];
        _grid_verticalHeaderScrollView.sectionHeaderHeight = 0;
        _grid_verticalHeaderScrollView.sectionFooterHeight = 0;
        _grid_verticalHeaderScrollView.rowHeight = 0;
        _grid_verticalHeaderScrollView.estimatedRowHeight = 0;
        _grid_verticalHeaderScrollView.estimatedSectionFooterHeight = 0;
        _grid_verticalHeaderScrollView.estimatedSectionHeaderHeight = 0;
        _grid_verticalHeaderScrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _grid_verticalHeaderScrollView;
}

- (UILabel *)cornerTitleLabel {
    if (!_cornerTitleLabel) {
        _cornerTitleLabel = [[UILabel alloc] init];
        _cornerTitleLabel.font = [UIFont systemFontOfSize:15];
        _cornerTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cornerTitleLabel;
}

- (NSMutableSet *)collectionContentIdentifiers {
    if (!_collectionContentIdentifiers) {
        _collectionContentIdentifiers = [[NSMutableSet alloc] init];
    }
    return _collectionContentIdentifiers;
}

@end
