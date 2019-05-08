//
//  MQTransitionPopCoverVertical.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPopCoverVertical.h"

@interface MQTransitionPopCoverVertical ()
@property (nonatomic, assign) CGRect dstFrame;
@end

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
    
    _dstFrame = CGRectMake(fromView.frame.origin.x, top,
                          fromView.frame.size.width, fromView.frame.size.height);
    [fromView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromView.frame = self.dstFrame;
    } completion:^(BOOL finished) {
        [fromView removeObserver:self forKeyPath:@"frame"];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGRect rect = [change[@"new"] CGRectValue];
    if (CGRectEqualToRect(rect, self.dstFrame)) return;
    
    // IQKeyboard may change the frame of fromView when pop
    UIView *fromView = (UIView *)object;
    fromView.frame = self.dstFrame;
    
    // prevent fromView flashing in pop animation
    for (NSString *key in fromView.layer.animationKeys) {
        if ([key isEqualToString:@"UIPacingAnimationForAnimatorsKey"] || [key isEqualToString:@"position"]) {
            continue;
        }
        
        [fromView.layer removeAnimationForKey:key];
    }
}

@end
