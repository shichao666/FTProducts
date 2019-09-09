//
//  UIButton+SCButton.m
//  FTTemplate
//
//  Created by 史超 on 2018/11/19.
//  Copyright © 2018年 史超. All rights reserved.
//

#import "UIButton+FTButton.h"
#import <objc/runtime.h>

@implementation UIButton (FTButton)

//根据文字创建按钮  默认文字 字体颜色黑色
+ (UIButton *)buttonWithTitle:(NSString *)title andAction:(buttonClicked)action {
    return [UIButton buttonWithTitle:title andTitleColor:[UIColor blackColor] andAction:action];
}

//根据文字创建按钮
+ (UIButton *)buttonWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andAction:(buttonClicked)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    if (action) {
        objc_setAssociatedObject(btn,@selector(buttonWithTitle:andTitleColor:andAction:), action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

//根据文字创建按钮  默认文字 字体颜色黑色
+ (UIButton *)buttonWithTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action{
    return [UIButton buttonWithTitle:title andTitleColor:[UIColor blackColor] andTarget:target andAction:action];
}

//根据文字创建按钮
+ (UIButton *)buttonWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTarget:(id)target andAction:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


+ (void)btnClicked:(UIButton *)btn {
    buttonClicked action = (buttonClicked)objc_getAssociatedObject(btn, @selector(buttonWithTitle:andTitleColor:andAction:));
    if (action) {
        action(btn);
    }
}

#pragma mark - UIButton下image和title的各种位置的分类封装
/**  设置button内部的image和title的布局样式  */
- (void)layoutButtonWithEdgeInsetsStyle:(HLButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space
{
    //1、得到imageView和titleLabel的宽、高
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat labelWidth = 0;
    CGFloat labelHeight = 0;
    if([UIDevice currentDevice].systemVersion.floatValue >=8.0)
    {
        //由于iOS8中titleLabel的size为0，分开设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    }
    else
    {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    //2、声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    //3、根据style和space设置
    switch (style) {
        case HLButtonEdgeInsetsStyleTop:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-space/2.0, 0);
            break;
        case HLButtonEdgeInsetsStyleLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, space/2.0);
            break;
        case HLButtonEdgeInsetsStyleBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, -imageWidth, 0);
            break;
        case HLButtonEdgeInsetsStyleRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - space/2.0, 0, imageWidth+space/2.0);
            break;
        default:
            break;
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
