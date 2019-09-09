//
//  UIFont+SCFont.m
//  QCMVVM
//
//  Created by 史超 on 2018/11/15.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "UIFont+FTFont.h"

#import <objc/runtime.h>

#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)

#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)

@implementation UIFont (FTFont)
/**
 *  ps和pt转换
 *
 *  @return UIFont
 */
+ (UIFont *)fontWithPixel:(CGFloat)pixel{
    /* ps和pt转换
     * px:相对长度单位。像素(Pixel)（ps字体）
     * pt:绝对长度单位。点(Point) (iOS字体)
     * 转换公式: pt = (px/96)*72
     *
     */
    
    CGFloat fontSize = (pixel/96)*72;
    return [UIFont systemFontOfSize:fontSize];
}

/**
 *  根据pixel获取相应的iOS加粗字体
 *
 *  @param pixel 像素
 *
 *  @return UIfont
 */
+ (UIFont *)boldFontWithPixel:(CGFloat)pixel{
    CGFloat fontSize = (pixel/96)*72;
    return [UIFont boldSystemFontOfSize:fontSize];
}


+ (void)load {
    Method newMethod = class_getClassMethod([self class], @selector(FTFont:));
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(newMethod, method);
}

/**
 默认字体
 */
+ (UIFont *)FTFont:(CGFloat)fontSize {
    UIFont *newFont=nil;
    if (IS_IPHONE_6){
        newFont = [UIFont FTFont:fontSize + 2];
    }else if (IS_IPHONE_6_PLUS){
        newFont = [UIFont FTFont:fontSize + 3];
    }else{
        newFont = [UIFont FTFont:fontSize];
    }
    return newFont;
}


@end
