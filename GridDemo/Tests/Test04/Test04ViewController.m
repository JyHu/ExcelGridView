//
//  Test04ViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/4.
//

#import "Test04ViewController.h"
#import "GridView.h"
#import "Tools.h"

@interface Test04ViewController () <ExcelGridViewDelegate>

@property (nonatomic, strong) ExcelGridView *gridView;

@end

@implementation Test04ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.gridView];
    
}

- (ExcelGridView *)gridView {
    if (!_gridView) {
//        _gridView = [[ExcelGridView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20 - 64) visualType:ExcelGridVisualTypeCollectionView delegate:self];
//        _gridView.backgroundColor = [UIColor whiteColor];
//        _gridView.layer.masksToBounds = YES;
//        _gridView.layer.borderWidth = 1;
//        _gridView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _gridView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
