//
//  MQTransitionPushCustomizedHorizontal.h
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/14.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQTransitionPushCustomizedHorizontal : NSObject

@property (nonatomic, assign) NSTimeInterval transitionDuration; //default 0.3s

@property (nonatomic, assign) NSUInteger fromUnit; //default 1, [1, MAX)
@property (nonatomic, assign) NSUInteger toUnit;   //default 1, [1, MAX)

- (void)animateTransitionWithFromViewCtrl:(UIViewController *)fromVC toViewCtrl:(UIViewController *)toVC;

@end

NS_ASSUME_NONNULL_END
