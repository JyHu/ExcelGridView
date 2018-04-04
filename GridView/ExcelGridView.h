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
    ExcelGridHorizontalHeaderTypeManual,        // 整个的自定义
};

@class ExcelGridView;
@class ExcelGridItemCell;

@protocol ExcelGridViewDelegate <ExcelGridFrameDelegate>

@optional

#pragma mark - 角标题

// 角标题视图
- (UIView *)cornerViewInGridView:(ExcelGridView *)gridView;
// 角标题
- (void)gridView:(ExcelGridView *)girdView titleOfCornerLabel:(UILabel *)label;

#pragma mark - 横向标题设置的代理方法

// 横向标题的类型
- (ExcelGridHorizontalHeaderType)horizontalHeaderTypeOfGridView:(ExcelGridView *)gridView;
// ExcelGridHorizontalHeaderTypeManual 类型对应的代理，需要返回一个UIScrollView或其子类视图
- (UIScrollView *)horizontalHeaderOfGridView:(ExcelGridView *)gridView;
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
- (UITableViewCell *)gridView:(ExcelGridView *)gridView titleCellOfVerticalHeaderAtIndexPath:(NSIndexPath *)indexPath;



#pragma mark - 设置内容区

// 内容的区的item，使用与CollectionView
- (void)gridView:(ExcelGridView *)girdView contentItemCell:(ExcelGridItemCell *)cell atIndexPath:(NSIndexPath *)indexPath;
// 内容区的cell，collectionview类型
- (UICollectionViewCell *)gridView:(ExcelGridView *)gridView contentItemCellAtIndexPath:(NSIndexPath *)indexPath;

// 内容区的cell，TableView方式
- (UITableViewCell *)gridView:(ExcelGridView *)gridView contentCellAtIndexPath:(NSIndexPath *)indexPath;



#pragma mark - 内容区、标题区都用得到的代理方法

// 有多少列
- (NSInteger)numberOfLinesInGridView:(ExcelGridView *)gridView;
// 有多少分组
- (NSInteger)numberOfSectionsInGridView:(ExcelGridView *)gridView;
// 内容区、左侧纵向标题区有多少行
- (NSInteger)gridView:(ExcelGridView *)gridView numberOfRowsInSection:(NSInteger)section;
// 内容区、左侧纵向标题区某一行的高度
- (CGFloat)gridView:(ExcelGridView *)gridView heightForRow:(NSInteger)row inSection:(NSInteger)section;
// 内容区、左侧纵向标题区的header的高度
- (CGFloat)gridView:(ExcelGridView *)gridView heightForHeaderInSection:(NSInteger)section;
// 内容区有多少列，同样适用于横向的标题
- (CGFloat)gridView:(ExcelGridView *)gridView widthForLineWithIndex:(NSInteger)lineIndex;


@end


@interface ExcelGridView : ExcelGridFrame

- (instancetype)initWithFrame:(CGRect)frame
                   visualType:(ExcelGridVisualType)visualType
                     delegate:(id <ExcelGridViewDelegate>)delegate;

- (instancetype)initWithVisualType:(ExcelGridVisualType)visualType
                          delegate:(id <ExcelGridViewDelegate>)delegate;



@property (nonatomic, weak, readonly) id <ExcelGridViewDelegate> delegate;

@property (nonatomic, assign, readonly) ExcelGridVisualType visualType;

@property (nonatomic, assign, readonly) ExcelGridHorizontalHeaderType horizontalHeaderType;


@end
