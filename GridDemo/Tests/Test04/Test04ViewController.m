//
//  Test04ViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/4.
//

#import "Test04ViewController.h"
#import "GridView.h"
#import "Tools.h"
#import "TestVertHeaderTableViewCell.h"
#import "TestHoriHeaderCollectionViewCell.h"
#import "TestContentItemCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface Test04ViewController () <ExcelGridViewDelegate>

@property (nonatomic, strong) ExcelGridView *gridView;

@end

@implementation Test04ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"使用GridView自定义cell";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.gridView];
    
    [self.gridView registerClass:[TestContentItemCollectionViewCell class] forCellInContentCollectionWithReuseIdentifier:@"testContentItemIdentifier"];
    
    [self.gridView registerClass:[TestContentItemCollectionViewCell class] forCellInHoriHeaderCollectionWithReuseIdentifier:@"testHoriCellIdentifier"];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.gridView.horizontalHeaderContainerView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.gridView.horizontalHeaderContainerView);
        make.height.equalTo(@2);
    }];
}

- (NSInteger)numberOfSectionsInGridView:(ExcelGridView *)gridView {
    return 10;
}

- (NSInteger)gridView:(ExcelGridView *)gridView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)gridView:(ExcelGridView *)gridView cellForVerticalHeaderAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *vertHeaderIdentifier = @"reused.vertHeaderIdentifier";
    TestVertHeaderTableViewCell *cell = [gridView.verticalHeaderTableView dequeueReusableCellWithIdentifier:vertHeaderIdentifier];
    if (!cell) {
        cell = [[TestVertHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vertHeaderIdentifier];
    }
    
    cell.indexPath = indexPath;
    cell.title = @"这里是标题";
    
    return cell;
}

- (UICollectionViewCell *)gridView:(ExcelGridView *)gridView cellForHorizontalHeaderAtIndex:(NSInteger)index {
    TestHoriHeaderCollectionViewCell *cell = [(UICollectionView *)gridView.horizontalHeaderScrollView dequeueReusableCellWithReuseIdentifier:@"testHoriCellIdentifier" forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.title = @"横T";
    return cell;
}

- (UICollectionViewCell *)gridView:(ExcelGridView *)gridView cellForContentItemAtIndexPath:(NSIndexPath *)indexPath {
    TestContentItemCollectionViewCell *cell = [(UICollectionView *)gridView.contentScrollView dequeueReusableCellWithReuseIdentifier:@"testContentItemIdentifier" forIndexPath:indexPath];
    cell.title = @"title";
    return cell;
}

- (ExcelGridView *)gridView {
    if (!_gridView) {
        _gridView = [[ExcelGridView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20 - 64 - 34 - 20)];
        _gridView.delegate = self;
        _gridView.gridVisualType = ExcelGridVisualTypeCollectionView;
        _gridView.horizontalHeaderType = ExcelGridHorizontalHeaderTypeCustomerCell;
        _gridView.horizontalHeaderHeight = 45;
        _gridView.verticalHeaderWidth = 120;
        _gridView.contentWidth = 900;
        _gridView.numberOfColumns = 10;
        _gridView.rowHeight = 44;
        _gridView.contentItemWidth = 90;
        _gridView.groupHeaderHeight = 10;
        _gridView.cornerTitle = @"Corner";
        _gridView.bounces = NO;
        
        _gridView.backgroundColor = [UIColor blueColor];
        _gridView.layer.masksToBounds = YES;
        _gridView.layer.borderWidth = 1;
        _gridView.layer.borderColor = [UIColor redColor].CGColor;
        
        [_gridView reloadData];
    }
    return _gridView;
}

- (NSString *)alertInfo {
    return @"使用封装好的GridView，自定义各部分的cell，来实现测试页面，右侧内容区使用的是CollectionView。";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
