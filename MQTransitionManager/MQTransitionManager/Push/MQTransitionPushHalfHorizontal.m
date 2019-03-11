//
//  MQTransitionPushHalfHorizontal.m
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/8.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import "MQTransitionPushHalfHorizontal.h"
#import "MQTransitionManager.h"

@interface MQTransitionPushHalfHorizontal ()
@property (nonatomic, assign) CGRect fromViewDstFrame;
@end

@implementation MQTransitionPushHalfHorizontal
- (instancetype)init {
    if (!(self = [super init])) return nil;
    
    _transitionDuration = 0.3;
    
    return self;
}

- (void)animateTransitionWithFromViewCtrl:(UIViewController *)fromVC toViewCtrl:(UIViewController *)toVC {
    UIView *fromView = fromVC.view;
    UIView *toView   = toVC.view;
    UIView *containerView = fromVC.parentViewController.view;
    
    // 只在push的时候重新执行动画
    CGFloat toViewX = toView.frame.origin.x < containerView.frame.size.width/2 ? containerView.frame.size.width : toView.frame.origin.x;
    toView.frame = CGRectMake(toViewX,                          0,
                              containerView.frame.size.width/2, containerView.frame.size.height);
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:self.transitionDuration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:20
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         fromView.frame = CGRectMake(fromView.frame.origin.x,          fromView.frame.origin.y,
                                                     containerView.frame.size.width/2, containerView.frame.size.height);
                         self->_fromViewDstFrame = fromView.frame;
                         
                         toView.frame = CGRectMake(containerView.frame.size.width/2,   0,
                                                   containerView.frame.size.width/2, containerView.frame.size.height);
                     } completion:^(BOOL finished) {
                         // addChildViewController 请在完成时再添加，不然会导致toVC默认导航栏异常
                         [fromVC.navigationController addChildViewController:toVC];
                         fromView.frame = self.fromViewDstFrame;
                         
                         // Magic (懒)
                         // 在完成自定义pop后就不需要了_(:з」∠)_
//                         [fromVC.navigationController pushViewController:[UIViewController new] animated:NO];
//                         [fromVC.navigationController popViewControllerAnimated:NO];
                         
                         // completion 在 viewDidAppear 后才执行, 先前的设置保留了Type, 但过场无效, 此处刷新
                         MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:toVC];
                         [transition resetPopType];
                         
                         // 虽然会出现fromVC navigationBar位置不对的情况Σ(っ °Д °;)っ
                         // 但是一般做了分屏跳转的页面都只在首页，首页使用默认导航栏的概率太小，不管了
                     }];
}

@end
