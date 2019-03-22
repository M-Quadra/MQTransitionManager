//
//  HalfNvgController.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/8.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "HalfNvgController.h"
#import "MQTransitionManager.h"

@interface HalfNvgController ()

@end

@implementation HalfNvgController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:self];
    [transition setPopType:transition.type];
}

@end
