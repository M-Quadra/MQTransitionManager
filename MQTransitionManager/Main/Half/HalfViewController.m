//
//  HalfViewController.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/8.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "HalfViewController.h"

@interface HalfViewController ()

@end

@implementation HalfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.title = @"nvg2";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 50, 50)];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(nxtBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)nxtBtnClick:(UIButton *)sender {
    HalfViewController *vc = [[HalfViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
