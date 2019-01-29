# MQTransitionManager

无忧push, pop丝滑,  Navigation大法好

需要使用`navigationController `的`delegate`

包含了一个类模态默认跳转的自定义过程, 自定义皆为全屏手势, 需要其他过程动画可自行扩充`TransitionType`

配合[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)食用效果更佳

# 使用方式

将项目中的'MQTransitionManager'文件夹拖到需要使用的工程中即可

### Push方法

在需要push的位置调用, `Type:`可选择不同的push动画类型

```
MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
[transition pushWithType:MQTransitionType_CoverVertical navigationController:self.navigationController];
```

### Pop方法

调用位置`- (void)viewDidAppear:(BOOL)animated`, `setPopType:`方法设置pop动画的类型

```
MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:self];
[transition setPopType:MQTransitionType_CoverVertical];
```

# 已知问题

pop过场取消时 IQKeyboardManager 在下次输入前不能及时复位

-

友情支持

[PetitPrince](https://github.com/vitanuan)