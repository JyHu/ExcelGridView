//
//  Test02ViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/3.
//

#import "Test02ViewController.h"
#import "GridView.h"
#import "CourseCollectionViewCell.h"
#import "Tools.h"
#import "UIColor+Helper.h"

@interface Test02ViewController ()
<
ExcelGridFrameDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) ExcelGridFrame *gridFrame;

@property (nonatomic, strong) UITableView *verticalTable;
@property (nonatomic, strong) UICollectionView *contentCollection;
@property (nonatomic, strong) UILabel *cornerTitleLabel;
@property (nonatomic, strong) UIScrollView *headerScroll;

@end

@implementation Test02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"使用GridFrame";
    
    [self.view addSubview:self.gridFrame];
    self.gridFrame.verticalHeaderTableView = self.verticalTable;
    self.gridFrame.contentScrollView = self.contentCollection;
    self.gridFrame.cornerView = self.cornerTitleLabel;
    self.gridFrame.horizontalHeaderScrollView = self.headerScroll;
    self.gridFrame.horizontalHeaderHeight = 45;
    self.gridFrame.contentWidth = 900;
    self.gridFrame.verticalHeaderWidth = 120;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *t01Identifier = @"t01Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t01Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t01Identifier];
    }
    
    cell.backgroundColor = [UIColor randomColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld - %ld", indexPath.section, indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"table view did selected");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CourseCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collection view did selected");
}

#pragma mark - getter

- (ExcelGridFrame *)gridFrame {
    if (!_gridFrame) {
        _gridFrame = [[ExcelGridFrame alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 64 - 20)];
        _gridFrame.backgroundColor = [UIColor redColor];
        _gridFrame.gridFrameDelegate = self;
    }
    return _gridFrame;
}

- (UITableView *)verticalTable {
    if (!_verticalTable) {
        _verticalTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _verticalTable.backgroundColor = [UIColor greenColor];
        _verticalTable.dataSource = self;
        _verticalTable.sectionHeaderHeight = 60;
        _verticalTable.sectionFooterHeight = 0;
    }
    return _verticalTable;
}

- (UICollectionView *)contentCollection {
    if (!_contentCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(90, 44);
        _contentCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollection.backgroundColor = [UIColor blueColor];
        _contentCollection.dataSource = self;
        [_contentCollection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CourseCollectionViewCell class])];
    }
    return _contentCollection;
}

- (UILabel *)cornerTitleLabel {
    if (!_cornerTitleLabel) {
        _cornerTitleLabel = [[UILabel alloc] init];
        _cornerTitleLabel.font = [UIFont systemFontOfSize:14];
        _cornerTitleLabel.text = @"Corner";
        _cornerTitleLabel.backgroundColor = [UIColor yellowColor];
    }
    return _cornerTitleLabel;
}

- (UIScrollView *)headerScroll {
    if (!_headerScroll) {
        _headerScroll = [[UIScrollView alloc] init];
        for (NSInteger i = 0; i < 10; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90 * i, 0, 90, 45)];
            label.text = [NSString stringWithFormat:@"NO.%ld", i];
            label.textAlignment = NSTextAlignmentCenter;
            [_headerScroll addSubview:label];
        }
        _headerScroll.contentSize = CGSizeMake(900, 45);
    }
    return _headerScroll;
}

- (NSString *)alertInfo {
    return @"使用封装的GridFrame，通过自定义框架里的各个子视图来实现测试页面";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
