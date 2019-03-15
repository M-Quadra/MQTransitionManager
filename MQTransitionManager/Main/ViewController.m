//
//  ViewController.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "ViewController.h"
#import "MQTransitionManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "HalfNvgController.h"
#import "HalfViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *transitionTypeAry;
@property (nonatomic, strong) NSArray *transitionTxtAry;
@end

@implementation ViewController
- (instancetype)init {
    if (!(self = [super init])) return nil;
    
    _transitionTypeAry = @[@(MQTransitionType_Normal), @(MQTransitionType_CoverVertical)];
    _transitionTxtAry = @[@"", @""];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.shouldResignOnTouchOutside = YES;
    
    self.view.backgroundColor = self.navigationController.viewControllers.count&1 ? [UIColor lightGrayColor] : [UIColor grayColor];
    self.navigationItem.title = [@(self.navigationController.viewControllers.count) stringValue];
    
    UIButton *btnLft = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    btnLft.backgroundColor = [UIColor redColor];
    [btnLft addTarget:self action:@selector(lftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLft];
    
    UIButton *btnRit = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 50, 50)];
    btnRit.backgroundColor = [UIColor greenColor];
    [btnRit addTarget:self action:@selector(ritBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRit];
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
    [self.view addSubview:txtField];
    [txtField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:self];
    [transition setPopType:self.navigationController.viewControllers.count&1 ? MQTransitionType_Normal : MQTransitionType_CoverVertical];
}

- (void)lftBtnClick:(UIButton *)sender {
//    ViewController *vc = [[ViewController alloc] init];
//
//    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
//    [transition pushWithType:MQTransitionType_Normal navigationController:self.navigationController];
    
    HalfViewController *vc = [[HalfViewController alloc] init];
    HalfNvgController *nvg = [[HalfNvgController alloc] initWithRootViewController:vc];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:nvg];
    [transition pushWithType:MQTransitionType_OneThirdHorizontal navigationController:self.navigationController];
}

- (void)ritBtnClick:(UIButton *)sender {
    ViewController *vc = [[ViewController alloc] init];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
    [transition pushWithType:MQTransitionType_CoverVertical navigationController:self.navigationController];
}
@end
