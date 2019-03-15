//
//  MQTransitionPopCustomizedHorizontal.h
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/3/15.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQTransitionPopCustomizedHorizontal : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) NSUInteger fromUnit; //default 1, [1, MAX)
@property (nonatomic, assign) NSUInteger toUnit;   //default 1, [1, MAX)
@end

NS_ASSUME_NONNULL_END
