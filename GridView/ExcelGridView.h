//
//  ExcelGridView.h
//  GridView
//
//  Created by 胡金友 on 2018/4/3.
//

#import "ExcelGridFrame.h"

typedef NS_ENUM(NSUInteger, ExcelGridVisualType) {
    ExcelGridVisualTypeTableView,       // 内容区是tableview
    ExcelGridVisualTypeCollectionView,  // 内容区是collectionview
};

typedef NS_ENUM(NSUInteger, ExcelGridHorizontalHeaderType) {
    ExcelGridHorizontalHeaderTypeNone,          // 没有header
    ExcelGridHorizontalHeaderTypeDefault,       // 默认的，collection
    ExcelGridHorizontalHeaderTypeCustomerCell,  // collection，自定义cell
    ExcelGridHorizontalHeaderTypeCustomerView,  // scrollview，自定义view
};

@class ExcelGridView;
@class ExcelGridItemCell;

@protocol ExcelGridViewDelegate <ExcelGridFrameDelegate>

@optional

#pragma mark - 横向标题设置的代理方法

// ExcelGridHorizontalHeaderTypeCustomerCell 类型对应的代理，需要返回一个 UICollectionViewCell
- (UICollectionViewCell *)gridView:(ExcelGridView *)gridView cellForHorizontalHeaderAtIndex:(NSInteger)index;
// ExcelGridHorizontalHeaderTypeCustomerView 类型对应的代理，需要返回一个 UIView类型的组件，放在ScrollView容器内
- (UIView *)gridView:(ExcelGridView *)gridView viewForHorizontalHeaderAtIndex:(NSInteger)index;
// ExcelGridHorizontalHeaderTypeDefault 类型对应的代理，需要返回横向标题的内容
- (void)gridView:(ExcelGridView *)gridView horizontalHeaderCell:(ExcelGridItemCell *)cell atIndex:(NSInteger)index;


#pragma mark - 纵向标题

// 设置纵向标题
- (void)gridView:(ExcelGridView *)girdView verticalHeaderCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
// 返回自定义的cell
- (UITableViewCell *)gridView:(ExcelGridView *)gridView cellForVerticalHeaderAtIndexPath:(NSIndexPath *)indexPath;


#pragma mark - 设置内容区

// 内容的区的item，使用与CollectionView
- (void)gridView:(ExcelGridView *)girdView contentItemCell:(ExcelGridItemCell *)cell atIndexPath:(NSIndexPath *)indexPath;
// 内容区的cell，collectionview类型
- (UICollectionViewCell *)gridView:(ExcelGridView *)gridView cellForContentItemAtIndexPath:(NSIndexPath *)indexPath;

// 内容区的cell，TableView方式
- (UITableViewCell *)gridView:(ExcelGridView *)gridView cellForContentAtIndexPath:(NSIndexPath *)indexPath;


#pragma mark - 内容区、标题区都用得到的代理方法

// 有多少列
- (NSInteger)numberOfColumnsInGridView:(ExcelGridView *)gridView;
// 内容区、左侧纵向标题区某一行的高度
- (CGFloat)gridView:(ExcelGridView *)gridView heightForRow:(NSInteger)row inSection:(NSInteger)section;
// 内容区、左侧纵向标题区的header的高度
- (CGFloat)gridView:(ExcelGridView *)gridView heightForHeaderInSection:(NSInteger)section;
// 内容区有多少列，同样适用于横向的标题
- (CGFloat)gridView:(ExcelGridView *)gridView widthForLineWithIndex:(NSInteger)lineIndex;

#pragma mark - 点击事件

- (void)gridView:(ExcelGridView *)gridView selectedRow:(NSInteger)row inSection:(NSInteger)section;
- (void)gridView:(ExcelGridView *)gridView selectedVertcalHeaderAtIndexPath:(NSIndexPath *)indexPath;
- (void)gridView:(ExcelGridView *)gridView selectedContentItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)gridView:(ExcelGridView *)gridView selectedHoriHeaderAtIndex:(NSInteger)index;
- (void)gridView:(ExcelGridView *)gridView selectedContentCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)gridView:(ExcelGridView *)gridView selectedLineWithIndex:(NSInteger)index;

#pragma mark - required

@required
// 有多少分组
- (NSInteger)numberOfSectionsInGridView:(ExcelGridView *)gridView;
// 内容区、左侧纵向标题区有多少行
- (NSInteger)gridView:(ExcelGridView *)gridView numberOfRowsInSection:(NSInteger)section;

@end

@interface ExcelGridView : ExcelGridFrame

/**
 右下角内容区的组织方式，只有设置了这个属性以后才会添加一个内容视图
 */
@property (assign, nonatomic) ExcelGridVisualType gridVisualType;

/**
 代理方法，用于事件的回传
 */
@property (weak, nonatomic) id <ExcelGridViewDelegate> delegate;

/**
 横标题的组织方式，只有设置了这个属性以后才会添加横标题视图，用于展示标题内容
 */
@property (assign, nonatomic) ExcelGridHorizontalHeaderType horizontalHeaderType;

@property (assign, nonatomic) NSUInteger numberOfColumns;     // 有多少列
@property (assign, nonatomic) CGFloat groupHeaderHeight;    // 横标题的高度
@property (assign, nonatomic) CGFloat contentItemWidth;     // 内容区每个item的宽度
@property (assign, nonatomic) CGFloat rowHeight;            // 每一行的高度

/**
 刷新所有的tableView、collectionView的数据
 */
- (void)reloadData;

/**
 在设置了内容区为collection以后，注册一个cell，外部在复用的时候可以直接取`contentScrollView`即可。
 */
- (void)registerClass:(Class)cls forCellInContentCollectionWithReuseIdentifier:(NSString *)identifier;

/**
 在设置横标题为collection以后注册一个cell，外部在复用的时候可以直接取`horizontalHeaderScrollView`即可。
 */
- (void)registerClass:(Class)cls forCellInHoriHeaderCollectionWithReuseIdentifier:(NSString *)identifier;

@end
