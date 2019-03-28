//
//  MQTransitionPopCustomizedHorizontal.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/15.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPopCustomizedHorizontal.h"
#import "MQTransitionManager.h"

@interface MQTransitionPopCustomizedHorizontal ()
@property (nonatomic, assign) CGRect toViewDstFrame;
@end

@implementation MQTransitionPopCustomizedHorizontal
- (instancetype)init {
    if (!(self = [super init])) return nil;
    
    _fromUnit = 1;
    _toUnit   = 1;
    
    return self;
}

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
    
    MQTransitionManager *fromManager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:fromVC];
    MQTransitionType fromPopType = fromManager.type;
    
    NSTimeInterval time = [self transitionDuration:transitionContext];
    
    toView.frame = CGRectMake(toView.frame.origin.x,                                                      toView.frame.origin.y,
                              containerView.frame.size.width/(self.fromUnit + self.toUnit) * self.toUnit, toView.frame.size.height);
    [transitionContext.containerView insertSubview:toView belowSubview:fromView];
    
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromView.frame = CGRectMake(containerView.frame.size.width, fromView.frame.origin.y,
                                    fromView.frame.size.width,      fromView.frame.size.height);
        toView.frame = CGRectMake(toView.frame.origin.x,          toView.frame.origin.y,
                                  containerView.frame.size.width, toView.frame.size.height);
        
        self->_toViewDstFrame = toView.frame;
    } completion:^(BOOL finished) {
        // 不执行任何navigationController push相关方法
        [transitionContext completeTransition:YES];
        if (!transitionContext.transitionWasCancelled) {
            if (CGRectEqualToRect(toView.frame, self.toViewDstFrame)) return;
            // in iOS 12.2
            // toView.frame.origin.x may be changed between "animations:" and "completion:" by Magic
            
            toView.frame = self.toViewDstFrame;
            return;
        }
        
        // 眨眼补帧∠( ᐛ 」∠)＿
        UIView *maskView = [[UIApplication sharedApplication].delegate.window snapshotViewAfterScreenUpdates:NO];
        [[UIApplication sharedApplication].delegate.window addSubview:maskView];
        
        // 若后续没有任何延迟操作与视图闪动情况可不使用眨眼补帧
        MQTransitionManager *fromManager = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:fromVC];
        [fromManager pushWithType:fromPopType navigationController:toVC.navigationController];
        
        [maskView removeFromSuperview];
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
