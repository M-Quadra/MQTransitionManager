//
//  MQTransitionManager.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionManager.h"
#import <objc/runtime.h>

#import "MQTransitionPushCoverVertical.h"
#import "MQTransitionPopCoverVertical.h"

#import "MQTransitionPushCustomizedHorizontal.h"
#import "MQTransitionPopCustomizedHorizontal.h"

@interface MQTransitionManager ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, weak) id<UINavigationControllerDelegate> lastDelegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSString *key;
@end

@implementation MQTransitionManager
+ (instancetype)shareManagerWithOperation:(UINavigationControllerOperation)operation viewController:(UIViewController *)vc {
    if (operation == UINavigationControllerOperationNone) return nil;
    MQTransitionManager *shareManager = nil;
    
    NSString *key = @"CutsceneManager";
    do {
        shareManager = objc_getAssociatedObject(vc, NSSelectorFromString(key));
        if (shareManager == nil) {
            shareManager = [[super alloc] initWithOperation:operation viewCtrl:vc key:key];
        } else if (![shareManager isKindOfClass:[self class]] || shareManager.operation != operation) {
            shareManager = nil;
            key = [key stringByAppendingString:@"嘤"];
        }
    } while (!shareManager);
    
    return shareManager;
}

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation viewCtrl:(UIViewController *)vc key:(NSString *)key {
    if (!(self = [super init])) return nil;
    
    _viewController = vc;
    _operation = operation;
    _key = key;
    objc_setAssociatedObject(vc, NSSelectorFromString(key), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewCtrlsDidChnage) name:MQTransitionManagerNotification_ViewControllersDidChange object:nil];
    
    return self;
}

- (void)pushWithType:(MQTransitionType)type navigationController:(UINavigationController *)nvgCtrl {
    if (!nvgCtrl || ![nvgCtrl isKindOfClass:[UINavigationController class]]) return;
    _navigationController = nvgCtrl;
    
    _type = type;
    _lastDelegate = self.navigationController.delegate;
    
    switch (type) {
        case MQTransitionType_None: {
            [self.navigationController pushViewController:self.viewController animated:NO];
            break;
        }
        case MQTransitionType_Normal: {
            [self.navigationController pushViewController:self.viewController animated:YES];
            break;
        }
        case MQTransitionType_CoverVertical: {
            self.navigationController.delegate = self;
            [self.navigationController pushViewController:self.viewController animated:YES];
            break;
        }
        case MQTransitionType_HalfHorizontal: {
            self.navigationController.delegate = self;
            MQTransitionPushCustomizedHorizontal *push = [[MQTransitionPushCustomizedHorizontal alloc] init];
            [push animateTransitionWithFromViewCtrl:nvgCtrl.viewControllers.lastObject toViewCtrl:self.viewController];
            break;
        }
        case MQTransitionType_OneThirdHorizontal: {
            self.navigationController.delegate = self;
            MQTransitionPushCustomizedHorizontal *push = [[MQTransitionPushCustomizedHorizontal alloc] init];
            push.fromUnit = 1;
            push.toUnit   = 2;
            [push animateTransitionWithFromViewCtrl:nvgCtrl.viewControllers.lastObject toViewCtrl:self.viewController];
            break;
        }
        default: {
            [self free];
            return;
        }
    }
}

- (void)setPopType:(MQTransitionType)type {
    _type = type;
    
    _navigationController = self.viewController.navigationController;
    if (!self.navigationController) return;
    
    // UINavigationController Delegate will later than viewDidAppear
    // use GCD to keep lastDelegate won' t been covered
    // UINavigationController Delegate变化回调在viewDidAppear后才执行
    // 为了保证从push过来的delegate还原前不被抢占这里直接延迟
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_lastDelegate = self.navigationController.delegate;
        
        if (MQTransitionType_None < type && type < MQTransitionType_Count) {
            self.navigationController.delegate = self;
        } else {
            [self free];
            return;
        }
        
        if (self.navigationController.delegate == self) {
            self.panGesture.enabled = YES;
            [self.panGesture addTarget:self action:@selector(panGestureAction:)];
            [self.navigationController.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
        }
    });
}

- (void)resetPopType {
    [self setPopType:self.type];
}

#pragma mark - Lazy
- (UIPanGestureRecognizer *)panGesture {
    if (self.operation == UINavigationControllerOperationPush) return nil;
    
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] init];
    }
    return _panGesture;
}

#pragma mark - Action
- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    CGPoint velocity = [pan velocityInView:[UIApplication sharedApplication].delegate.window];
    CGFloat process = [pan translationInView:self.viewController.view].x / ([UIScreen mainScreen].bounds.size.width);
    process = MAX(0, process);
    process = MIN(process, 1);
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (velocity.x < 0 || ABS(velocity.y/velocity.x) > tanf(35.0 * M_PI/180.0)) {
            [pan cancelsTouchesInView];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [self.interactiveTransition updateInteractiveTransition:process];
    } else {
        if (process > 0.4 || velocity.x > 900) {
            [self.interactiveTransition finishInteractiveTransition];
            // 小概率出现finish后触发cancel, 导致导航栏莫名消失
            // 因此在finish后直接释放interactiveTransition
            _interactiveTransition = nil;
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
    }
}

- (void)viewCtrlsDidChnage {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (self.operation == UINavigationControllerOperationPush) {
        if (viewControllers.lastObject != self.viewController) return;
        [self free];
    } else if (self.operation == UINavigationControllerOperationPop) {
        if (viewControllers.lastObject == self.viewController) {
            self.panGesture.enabled = YES;
        } else if (![viewControllers containsObject:self.viewController]) {
            [self free];
        } else {
            _panGesture.enabled = NO;
        }
    }
}

- (void)free {
//#ifdef DEBUG
//    NSLog(@"free MQTransitionManager for %@ key: %@", NSStringFromClass([self.viewController class]), self.key);
//#endif
    
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = self.lastDelegate;
    }
    [self.navigationController.interactivePopGestureRecognizer.view removeGestureRecognizer:_panGesture];
    objc_setAssociatedObject(self.viewController, &_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UINavigationController Delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation != self.operation || operation == UINavigationControllerOperationNone) return nil;
    if (operation == UINavigationControllerOperationPop && fromVC != self.viewController) return nil;
    
    switch (self.type) {
        case MQTransitionType_CoverVertical: {
            return operation == UINavigationControllerOperationPush ? [MQTransitionPushCoverVertical new] : [MQTransitionPopCoverVertical new];
        }
        case MQTransitionType_HalfHorizontal: {
            return operation == UINavigationControllerOperationPush ? nil : [MQTransitionPopCustomizedHorizontal new];
        }
        case MQTransitionType_OneThirdHorizontal: {
            if (operation == UINavigationControllerOperationPush) return nil;
            MQTransitionPopCustomizedHorizontal *pop = [MQTransitionPopCustomizedHorizontal new];
            pop.fromUnit = 2;
            pop.toUnit   = 1;
            return pop;
        }
        default: break;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.operation != UINavigationControllerOperationPop) return nil;
    // prevent conflict on BackBtnClick
    // 防止点击冲突
    if (self.panGesture.state == UIGestureRecognizerStatePossible || self.panGesture.state == UIGestureRecognizerStateFailed) return nil;
    
    if (!self.interactiveTransition) {
        _interactiveTransition = [UIPercentDrivenInteractiveTransition new];
    }
    return self.interactiveTransition;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // later than -viewDidAppear
    // 在viewDidAppear后触发
    [[NSNotificationCenter defaultCenter] postNotificationName:MQTransitionManagerNotification_ViewControllersDidChange object:nil];
    return;
}
@end
