//
//  MQTransitionPushCoverVertical.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPushCoverVertical.h"

@implementation MQTransitionPushCoverVertical
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.27;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!fromView) fromView = fromVC.view;
    if (!toView)   toView   = toVC.view;
    
    CGFloat top = toView.frame.origin.y;
    toView.frame = CGRectMake(toView.frame.origin.x, transitionContext.containerView.frame.size.height,
                              toView.frame.size.width, toView.frame.size.height);
    [[transitionContext containerView] addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toView.frame = CGRectMake(toView.frame.origin.x, top,
                                  toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end
