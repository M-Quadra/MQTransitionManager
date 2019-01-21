//
//  MQTransitionPopCoverVertical.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPopCoverVertical.h"

@implementation MQTransitionPopCoverVertical
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!fromView) fromView = fromVC.view;
    if (!toView)   toView   = toVC.view;
    
    NSTimeInterval time = [self transitionDuration:transitionContext];
    CGFloat top = transitionContext.containerView.frame.size.height;
    [transitionContext.containerView insertSubview:toView belowSubview:fromView];
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromView.frame = CGRectMake(fromView.frame.origin.x, top,
                                    fromView.frame.size.width, fromView.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end