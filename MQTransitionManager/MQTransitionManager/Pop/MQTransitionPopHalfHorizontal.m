//
//  MQTransitionPopHalfHorizontal.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/8.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPopHalfHorizontal.h"
#import "MQTransitionPushCustomizedHorizontal.h"

@implementation MQTransitionPopHalfHorizontal
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    if (!fromView) fromView = fromVC.view;
    if (!toView)   toView   = toVC.view;
    
    NSTimeInterval time = [self transitionDuration:transitionContext];
    
    toView.frame = CGRectMake(toView.frame.origin.x,            toView.frame.origin.y,
                              containerView.frame.size.width/2, toView.frame.size.height);
    [transitionContext.containerView insertSubview:toView belowSubview:fromView];
    

    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromView.frame = CGRectMake(containerView.frame.size.width, fromView.frame.origin.y,
                                    fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = containerView.bounds;
    } completion:^(BOOL finished) {
        // 不执行任何navigationController push相关方法
        [transitionContext completeTransition:YES];
        
        if (transitionContext.transitionWasCancelled) {
            // 眨眼补帧∠( ᐛ 」∠)＿
            UIView *maskView = [[UIApplication sharedApplication].delegate.window snapshotViewAfterScreenUpdates:NO];
            [[UIApplication sharedApplication].delegate.window addSubview:maskView];

            // 若后续没有任何延迟操作与视图闪动情况可不使用眨眼补帧
            MQTransitionPushCustomizedHorizontal *push = [[MQTransitionPushCustomizedHorizontal alloc] init];
            push.fromUnit = 1;
            push.toUnit   = 1;
            push.transitionDuration = 0;
            [push animateTransitionWithFromViewCtrl:toVC toViewCtrl:fromVC];
            [maskView removeFromSuperview];
        }
    }];
}

@end
