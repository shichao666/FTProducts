//
//  TFBaseNavigationController.m
//  FTTemplate
//
//  Created by 史超 on 2018/11/21.
//  Copyright © 2018年 史超. All rights reserved.
//

#import "TFBaseNavigationController.h"

@interface TFBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
