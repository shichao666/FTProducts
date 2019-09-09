//
//  FTBaseViewController.m
//  FTTemplate
//
//  Created by 史超 on 2018/11/20.
//  Copyright © 2018年 史超. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTCommonMacro.h"
@interface FTBaseViewController ()

@end

@implementation FTBaseViewController

#pragma -mark 懒加载
- (UIButton*)leftBarItemBtn {
    if (!_leftBarItemBtn) {
        _leftBarItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBarItemBtn.frame = CGRectMake(0, 0, 30, 44);
        [_leftBarItemBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftBarItemBtn setImage:[UIImage imageNamed:@"nav_back_image"] forState:UIControlStateNormal];
    }
    return _leftBarItemBtn;
}

- (UIButton*)rightBarItemBtn {
    if (!_rightBarItemBtn) {
        _rightBarItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBarItemBtn.frame = CGRectMake(0, 0, 60, 44);
        [_rightBarItemBtn addTarget:self action:@selector(rightBarItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rightBarItemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBarItemBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _rightBarItemBtn;
}


//隐藏返回按钮
- (void)hiddenBackButton {
    self.leftBarItemBtn.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

//返回事件重写 用于监听返回事件
-(void)backButtonClick {
    LogFunc
    [self.navigationController popViewControllerAnimated:YES];
}

//点击右侧按钮
- (void)rightBarItemBtnClick {
    LogFunc
}

//添加右侧功能按钮
- (void)addRightItemWithTitle:(NSString *)title andImageName:(NSString *)imageName {
    if (!title && !imageName) {
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarItemBtn];
    if (title) {
        [self.rightBarItemBtn setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        [self.rightBarItemBtn setImage:imageWithName(imageName) forState:UIControlStateNormal];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁止滑动返回
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //设置背景颜色
    self.view.backgroundColor = RGBA(246, 246, 246, 1);
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //有上级界面添加返回按钮
    if ([self.navigationController.viewControllers indexOfObject:self] > 0) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarItemBtn];
    }

    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
