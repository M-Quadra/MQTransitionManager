# MQTransitionManager

> Navigation大法好

需要使用`navigationController `的`delegate`

包含了一个类模态默认过场与可自定比例的分屏push, 自定义皆为全屏手势, 需要其他过程动画可自行调教`TransitionType`

集成[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

# 安装

### CocoaPods

1. 在Podfile中添加`pod 'MQTransitionManager'`
2. 执行`pod install`或`pod update`
3. 导入头文件

### 拖库

1. 下载`MQTransitionManager/MQTransitionManager`
2. 拖
3. 万一你真的不用`UIKit`请链接一下这个frameworks
4. 请随意调教MQTransitionType

# 使用方式

头文件
  
```
#import <MQTransitionManager/MQTransitionManager.h>
```

### Push方法

在需要push的位置调用, `Type:`可选择不同的push动画类型

```
MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPush viewController:vc];
[transition pushWithType:MQTransitionType_CoverVertical navigationController:self.navigationController];
```

### Pop方法

在`viewDidAppear:`中设置pop动画的类型

```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MQTransitionManager *transition = [MQTransitionManager shareManagerWithOperation:UINavigationControllerOperationPop viewController:self];
    [transition setPopType:MQTransitionType_CoverVertical];
}
```

# 已知问题

1. iOS12 pop过场取消时, 若存在激活中的`英文键盘`, 则会出现键盘显示下沉, 并且在下次输入触发前无法及时复位(疑似系统问题)
2. 分屏push模式是原本是专门为iPad考虑的, 由于首页几乎都是不使用系统原生导航栏, 经过分屏push后, 原导航栏会存在显示问题, 懒得研究

# 依赖

[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

# 未来巨坑

- 一别英语三十年, 致死不曾过四级
- 不是我吹, 连续参加过英语补考的人就我一个
- 有空想加英文说明\_(ˊཀˋ」∠)_
- 哪天有空把文档写完了, 就进0.1.0版本吧\_(:з」∠)_
- 0.0.3预计把类模态默认转场调整到接近系统的效果
- 说不定哪天心（闲）血（得）来（蛋）潮（疼）就会加新的效果

# 已为陈迹

## 0.0.2

- 修改了通知的命名风格, 并移动到内部
- 对IQKeyboardManager的兼容更好了, 之前在垂直转场动画开始触发的动画效果在pop取消时会造成意外的视图偏移, 于是就把多余的动画干掉了, 顺便给IQKeyboardManager提了pr, 本来不是很想管的, 但毕竟要弄点什么升版本才能名正言顺啊

## 0.0.1

- 因为懒得拖文件, 所以上CocoaPods
- 因为懒得写代码, 所以依赖FDFullscreenPopGesture
- 因为懒得关安全区, 所以iOS9起步

友情支持

[PetitPrince](https://github.com/vitanuan)