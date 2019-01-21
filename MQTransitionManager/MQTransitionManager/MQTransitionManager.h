//
//  MQTransitionManager.h
//  MQTransitionManager
//
//  Created by M_Quadra on 2019/1/17.
//  Copyright © 2019 M_noAria. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MQTransitionType) {
    MQTransitionType_None = 0,
    MQTransitionType_Normal,
    MQTransitionType_CoverVertical,// similar present default animation 类模态默认转场
};

#define MQTransitionManagerNotification_ViewControllersDidChange @"MQTransitionManagerNotification_ViewControllersDidChange"

NS_ASSUME_NONNULL_BEGIN

@interface MQTransitionManager : NSObject
+ (instancetype)new                                  NS_UNAVAILABLE;
+ (instancetype)alloc                                NS_UNAVAILABLE;
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)shareManagerWithOperation:(UINavigationControllerOperation)operation viewController:(UIViewController *)vc;

@property (nonatomic, weak, readonly) UINavigationController *navigationController;
@property (nonatomic, weak, readonly) UIViewController       *viewController;
@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;
@property (nonatomic, assign, readonly) MQTransitionType                type;

- (void)pushWithType:(MQTransitionType)type navigationController:(UINavigationController *)nvgCtrl;
- (void)setPopType:(MQTransitionType)type;
@end

NS_ASSUME_NONNULL_END