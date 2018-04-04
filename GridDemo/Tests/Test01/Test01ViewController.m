//
//  Test01ViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/3.
//

#import "Test01ViewController.h"
#import "Tools.h"
#import "CourseModel.h"
#import "NSDate+Helper.h"
#import "CourseCollectionViewCell.h"

@interface Test01ViewController () <
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UITableView *tableView;               // 左边的竖着的标题
@property (nonatomic, strong) UIScrollView *contentScroll;          // 右侧的容器视图
@property (nonatomic, strong) UIScrollView *headerScroll;           // 顶部的横向标题
@property (nonatomic, strong) UICollectionView *collectionView;     // 右侧的内容视图，也可以用table
@property (nonatomic, strong) UILabel *cornerLabel;                 // 角标题

@property (nonatomic, assign) CGFloat verticalHeaderWidth;      // 左侧竖向标题的宽度
@property (nonatomic, assign) CGFloat horizontalHeaderHeight;   // 顶部横向标题的宽度
@property (nonatomic, assign) CGFloat courseItemWidth;          // collectionview每个item的宽度

// 数据源
@property (nonatomic, strong) NSMutableArray <NSArray <CourseModel *> *> *datas;

@end

@implementation Test01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.verticalHeaderWidth = 135;
    self.horizontalHeaderHeight = 30;
    self.courseItemWidth = 60;
    
    for (NSInteger i = 0; i < 10; i ++) {
        NSMutableArray <CourseModel *> *tempArr = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < 20; j ++) {
            CourseModel *model = [[CourseModel alloc] init];
            model.date = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * i].dateString;
            [tempArr addObject:model];
        }
        [self.datas addObject:tempArr];
    }
    
    [self.view addSubview:self.cornerLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.contentScroll];
    [self.contentScroll addSubview:self.collectionView];
    [self.view addSubview:self.headerScroll];
}

#pragma mark - table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusefulCellIdentifier = @"reusefulCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusefulCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusefulCellIdentifier];
    }
    
    CourseModel *model = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = model.date;
    cell.backgroundColor = indexPath.row % 2 == 0 ?  [UIColor whiteColor] : [UIColor grayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35 + (indexPath.row % 2 == 0 ? 10 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10e-10 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseModel *model = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self alertTest:model.date];
}

#pragma mark - collection view delegate datasource flowlayoutdelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas[section].count * 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGSizeZero : CGSizeMake(CGRectGetWidth(collectionView.frame), 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ((NSInteger)(indexPath.row / 10)) % 2 == 0 ? 10 : 0;
    return CGSizeMake(self.courseItemWidth, height + 35);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CourseCollectionViewCell class]) forIndexPath:indexPath];
    
    NSInteger row = ((NSInteger)(indexPath.row / 10));
    cell.backgroundColor = row % 2 == 0 ? [UIColor whiteColor] : [UIColor grayColor];
    
    CourseModel *model = self.datas[indexPath.section][row];
    cell.titleLabel.text = [model courseAt:indexPath.row % 10];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = ((NSInteger)(indexPath.row / 10));
    CourseModel *model = self.datas[indexPath.section][row];
    [self alertTest:[model courseAt:indexPath.row % 10]];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self judgementFor:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self judgementFor:scrollView];
}

#pragma mark - helper

- (void)judgementFor:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        self.collectionView.contentOffset = scrollView.contentOffset;
    } else if ([scrollView isEqual:self.collectionView]) {
        self.tableView.contentOffset = scrollView.contentOffset;
    } else if ([scrollView isEqual:self.contentScroll]) {
        self.headerScroll.contentOffset = scrollView.contentOffset;
    } else if ([scrollView isEqual:self.headerScroll]) {
        self.contentScroll.contentOffset = scrollView.contentOffset;
    }
}

- (void)alertTest:(NSString *)text {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"点击提醒" message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - getter setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, self.horizontalHeaderHeight,
                                 self.verticalHeaderWidth, kScreenHeight - 64 - self.horizontalHeaderHeight)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (UIScrollView *)contentScroll {
    if (!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] initWithFrame:
                          CGRectMake(self.verticalHeaderWidth + 1,
                                     self.horizontalHeaderHeight,
                                     kScreenWidth - self.verticalHeaderWidth,
                                     kScreenHeight - self.horizontalHeaderHeight - 64)];
        _contentScroll.contentSize = CGSizeMake(self.courseItemWidth * 10, CGRectGetHeight(_contentScroll.frame));
        _contentScroll.delegate = self;
        _contentScroll.clipsToBounds = YES;
    }
    return _contentScroll;
}

- (UIScrollView *)headerScroll {
    if (!_headerScroll) {
        _headerScroll = [[UIScrollView alloc] initWithFrame:
                         CGRectMake(self.verticalHeaderWidth, 0,
                                    kScreenWidth - self.verticalHeaderWidth,
                                    self.horizontalHeaderHeight)];
        _headerScroll.backgroundColor = [UIColor redColor];
        
        for (NSInteger i = 0; i < 10; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(i * self.courseItemWidth, 0, self.courseItemWidth, self.horizontalHeaderHeight);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"NO.%@", @(i)];
            [_headerScroll addSubview:label];
        }
    }
    return _headerScroll;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:
                           CGRectMake(0, 0, self.contentScroll.contentSize.width,
                                      kScreenHeight - self.horizontalHeaderHeight - 64)
                                             collectionViewLayout:flowLayout];
        
        [_collectionView registerClass:[CourseCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([CourseCollectionViewCell class])];
        
        _collectionView.backgroundColor = [UIColor blueColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray<NSArray<CourseModel *> *> *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (UILabel *)cornerLabel {
    if (!_cornerLabel) {
        _cornerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.verticalHeaderWidth, self.horizontalHeaderHeight)];
        _cornerLabel.font = [UIFont boldSystemFontOfSize:18];
        _cornerLabel.textAlignment = NSTextAlignmentCenter;
        _cornerLabel.text = @"角 标";
        _cornerLabel.textColor = [UIColor yellowColor];
        
    }
    return _cornerLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
