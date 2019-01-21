//
//  ViewController.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "ViewController.h"
#import "MQTransitionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = [@(self.navigationController.viewControllers.count) stringValue];
    
    UIButton *btnLft = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    btnLft.backgroundColor = [UIColor redColor];
    [btnLft addTarget:self action:@selector(lftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLft];
    
    UIButton *btnRit = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 50, 50)];
    btnRit.backgroundColor = [UIColor greenColor];
    [btnRit addTarget:self action:@selector(ritBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:self];
    [transition setPopType:self.navigationController.viewControllers.count&1 ? MQTransitionType_Normal : MQTransitionType_CoverVertical];
}

- (void)lftBtnClick:(UIButton *)sender {
    ViewController *vc = [[ViewController alloc] init];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
    [transition pushWithType:MQTransitionType_Normal navigationController:self.navigationController];
}

- (void)ritBtnClick:(UIButton *)sender {
    ViewController *vc = [[ViewController alloc] init];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
    [transition pushWithType:MQTransitionType_CoverVertical navigationController:self.navigationController];
}
@end
