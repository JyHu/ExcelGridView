//
//  BaseTestViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/11.
//

#import "BaseTestViewController.h"

@interface BaseTestViewController ()

@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleDone target:self action:@selector(showAlert)];
}

- (void)showAlert {
    NSString *info = [self alertInfo];
    
    if (!info) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"说明" message:info preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)alertInfo {
    return nil;
}

@end
