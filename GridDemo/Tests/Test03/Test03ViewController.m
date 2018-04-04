//
//  Test03ViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/4.
//

#import "Test03ViewController.h"
#import "GridView.h"
#import "Tools.h"
#import "UIColor+Helper.h"

@interface Test03ViewController () <ExcelGridViewDelegate>

@property (nonatomic, strong) ExcelGridView *gridView;

@end

@implementation Test03ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.gridView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (ExcelGridHorizontalHeaderType)horizontalHeaderTypeOfGridView:(ExcelGridView *)gridView {
    return ExcelGridHorizontalHeaderTypeDefault;
}

- (void)gridView:(ExcelGridView *)gridView horizontalHeaderCell:(ExcelGridItemCell *)cell atIndex:(NSInteger)index {
    cell.textLabel.text = @"AA";
    cell.backgroundColor = [UIColor randomColor];
}

- (void)gridView:(ExcelGridView *)girdView titleOfCornerLabel:(UILabel *)label {
    label.text = @"Corner";
    label.backgroundColor = [UIColor randomColor];
}

- (void)gridView:(ExcelGridView *)girdView verticalHeaderCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = @"H";
    cell.backgroundColor = [UIColor randomColor];
}

- (NSInteger)numberOfSectionsInGridView:(ExcelGridView *)gridView {
    return 10;
}

- (NSInteger)gridView:(ExcelGridView *)gridView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfLinesInGridView:(ExcelGridView *)gridView {
    return 10;
}

- (CGFloat)contentWidthInGridFrame:(ExcelGridFrame *)gridFrame {
    return 900;
}

- (CGFloat)gridView:(ExcelGridView *)gridView widthForLineWithIndex:(NSInteger)lineIndex {
    return 90;
}

- (CGFloat)gridView:(ExcelGridView *)gridView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)heightForHorizontalHeaderInGridFrame:(ExcelGridFrame *)gridFrame {
    return 45;
}

- (CGFloat)widthForVerticalHeaderInGridFrame:(ExcelGridFrame *)gridFrame {
    return 120;
}

- (void)gridView:(ExcelGridView *)girdView contentItemCell:(ExcelGridItemCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = @"Content";
    cell.backgroundColor = [UIColor randomColor];
}


- (ExcelGridView *)gridView {
    if (!_gridView) {
        _gridView = [[ExcelGridView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20 - 64) visualType:ExcelGridVisualTypeCollectionView delegate:self];
        _gridView.backgroundColor = [UIColor whiteColor];
        _gridView.layer.masksToBounds = YES;
        _gridView.layer.borderWidth = 1;
        _gridView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _gridView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
