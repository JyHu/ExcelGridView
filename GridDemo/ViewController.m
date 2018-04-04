//
//  ViewController.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/3.
//

#import "ViewController.h"
#import "Test01ViewController.h"
#import "Test02ViewController.h"
#import "Test03ViewController.h"
#import "Test04ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)test01:(id)sender {
    [self.navigationController pushViewController:[[Test01ViewController alloc] init] animated:YES];
}

- (IBAction)test02:(id)sender {
    [self.navigationController pushViewController:[[Test02ViewController alloc] init] animated:YES];
}

- (IBAction)test03:(id)sender {
    [self.navigationController pushViewController:[[Test03ViewController alloc] init] animated:YES];
}

- (IBAction)test04:(id)sender {
    [self.navigationController pushViewController:[[Test04ViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
