//
//  ViewController.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "ViewController.h"
#import "MQTransitionManager.h"
#if __has_include(<IQKeyboardManager/IQKeyboardManager.h>)
#import <IQKeyboardManager/IQKeyboardManager.h>
#endif
#import "HalfNvgController.h"
#import "HalfViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *transitionTypeAry;
@property (nonatomic, strong) NSArray *transitionTxtAry;
@end

@implementation ViewController
- (instancetype)init {
    if (!(self = [super init])) return nil;
    
    _transitionTypeAry = @[@(MQTransitionType_Normal),
                           @(MQTransitionType_CoverVertical),
                           @(MQTransitionType_HalfHorizontal),
                           @(MQTransitionType_OneThirdHorizontal)];
    
    _transitionTxtAry = @[@"Normal",
                          @"CoverVertical",
                          @"HalfHorizontal",
                          @"OneThirdHorizontal"];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    tbView.delegate   = self;
    tbView.dataSource = self;
    
    [self.view addSubview:tbView];
    
#if __has_include(<IQKeyboardManager/IQKeyboardManager.h>)
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.shouldResignOnTouchOutside = YES;
//    keyboardManager.enable = NO;
#endif
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(100, 50, 200, 20)];
    txtField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:txtField];
    [txtField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:self];
    [transition setPopType:self.navigationController.viewControllers.count&1 ? MQTransitionType_Normal : MQTransitionType_CoverVertical];
}

- (void)ritBtnClick:(UIButton *)sender {
    ViewController *vc = [[ViewController alloc] init];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
    [transition pushWithType:MQTransitionType_CoverVertical navigationController:self.navigationController];
}

#pragma mark - TableView/DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transitionTxtAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.transitionTxtAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MQTransitionType pushType = [self.transitionTypeAry[indexPath.row] integerValue];
    
    if (pushType < MQTransitionType_HalfHorizontal) {
        ViewController *vc = [ViewController new];
        MQTransitionManager *manager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
        [manager pushWithType:pushType navigationController:self.navigationController];
        return;
    }
    
    HalfViewController *vc = [[HalfViewController alloc] init];
    HalfNvgController *nvg = [[HalfNvgController alloc] initWithRootViewController:vc];
    
    MQTransitionManager *manager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:nvg];
    [manager pushWithType:pushType navigationController:self.navigationController];
    
    manager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:nvg];
    [manager setPopType:pushType];
}

@end
