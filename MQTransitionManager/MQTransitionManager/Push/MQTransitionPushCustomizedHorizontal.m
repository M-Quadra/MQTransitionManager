//
//  MQTransitionPushCustomizedHorizontal.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/14.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPushCustomizedHorizontal.h"
#import "MQTransitionManager.h"

@interface MQTransitionPushCustomizedHorizontal ()
@property (nonatomic, assign) CGRect fromViewDstFrame;
@property (nonatomic, assign) CGRect toViewDstFrame;
@end

@implementation MQTransitionPushCustomizedHorizontal
- (instancetype)init {
    if (!(self = [super init])) return nil;
    
    _transitionDuration = 0.3;
    _fromUnit = 1;
    _toUnit   = 1;
    
    return self;
}

- (void)animateTransitionWithFromViewCtrl:(UIViewController *)fromVC toViewCtrl:(UIViewController *)toVC {
    UIView *fromView = fromVC.view;
    UIView *toView   = toVC.view;
    UIView *containerView = fromVC.parentViewController.view;

    MQTransitionManager *toManager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:toVC];
    MQTransitionType toPushType = toManager.type;
    
    CGFloat containerWidth = containerView.frame.size.width;
    CGFloat fromHeight = fromView.frame.size.height;
    
    _fromViewDstFrame = CGRectMake(0,                                                            fromView.frame.origin.y,
                                   containerWidth/(self.fromUnit + self.toUnit) * self.fromUnit, fromHeight);
    _toViewDstFrame = CGRectMake(CGRectGetMaxX(self.fromViewDstFrame),              self.fromViewDstFrame.origin.y,
                                 containerWidth - self.fromViewDstFrame.size.width, fromHeight);
    
    // 只在push的时候重新执行动画
    CGFloat toViewX = toView.frame.origin.x < self.toViewDstFrame.origin.x/2 ? containerWidth : toView.frame.origin.x;
    toView.frame = CGRectMake(toViewX,                        self.toViewDstFrame.origin.y,
                              self.toViewDstFrame.size.width, fromHeight);
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:self.transitionDuration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:20
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         fromView.frame = self.fromViewDstFrame;
                         toView.frame   = self.toViewDstFrame;
                     } completion:^(BOOL finished) {
                         // addChildViewController 请在完成时再添加，不然会导致toVC默认导航栏异常
                         [fromVC.navigationController addChildViewController:toVC];
                         fromView.frame = self.fromViewDstFrame;
                         
                         // completion 在 viewDidAppear 后才执行, 先前的设置保留了Type, 但过场无效, 此处刷新
                         MQTransitionManager *toManager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:toVC];
                         MQTransitionType toPopType = toManager.type;
                         if (toPopType != toPushType) {// Magic (懒)
                             [fromVC.navigationController pushViewController:[UIViewController new] animated:NO];
                             [fromVC.navigationController popViewControllerAnimated:NO];
#ifdef DEBUG
                             NSLog(@"[MQTransitionManager] warning: pushType need equal pop in CustomizedHorizontal!");
#endif
                         } else {
                             [toManager resetPopType];
                         }
                         
                         // 虽然会出现fromVC navigationBar位置不对的情况Σ(っ °Д °;)っ
                         // 但是一般做了分屏跳转的页面都只在首页，首页使用默认导航栏的概率太小，不管了
                     }];
}

#pragma mark - Setter
- (void)setFromUnit:(NSUInteger)fromUnit {
    fromUnit = MAX(1, fromUnit);
    _fromUnit = fromUnit;
}

- (void)setToUnit:(NSUInteger)toUnit {
    toUnit = MAX(1, toUnit);
    _toUnit = toUnit;
}

@end
