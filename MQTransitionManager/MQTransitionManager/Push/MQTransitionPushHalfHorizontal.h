//
//  MQTransitionPushHalfHorizontal.h
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/8.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQTransitionPushHalfHorizontal : NSObject

@property (nonatomic, assign) NSTimeInterval transitionDuration;// default 0.3s

- (void)animateTransitionWithFromViewCtrl:(UIViewController *)fromVC toViewCtrl:(UIViewController *)toVC;

@end

NS_ASSUME_NONNULL_END
