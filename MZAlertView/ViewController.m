//
//  ViewController.m
//  MZAlert
//
//  Created by 崔俊红 on 15/8/14.
//  Copyright (c) 2015年 崔俊红. All rights reserved.
//

#import "ViewController.h"
#import "MZAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alertAct:(id)sender {
    MZAlertView *alertView = [MZAlertView alertWithTitle:@"" message:@"我们都是开心的码侬，我们都为软件事业奋斗终身！" preferredStyle:MZAlertViewStyleAlert];
    [alertView addAction:[MZAlertAction actionWithTitle:@"确定" handler:^(MZAlertAction *action) {
        NSLog(@"hello");
    }]];
    [alertView show];
}

- (IBAction)sheetAct:(id)sender {
    MZAlertView *alertView = [MZAlertView alertWithTitle:nil message:nil preferredStyle:MZAlertViewStyleSheet];
    [alertView addAction:[MZAlertAction actionWithTitle:@"确定" handler:^(MZAlertAction *action) {
        NSLog(@"OK");
    }]];
    [alertView addAction:[MZAlertAction actionWithTitle:@"取消" handler:^(MZAlertAction *action) {
        NSLog(@"Cancel");
    }]];
    [alertView show];
}

@end
