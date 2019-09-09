//
//  UIColor+SCColor.m
//  QCMVVM
//
//  Created by 史超 on 2018/11/15.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "UIColor+FTColor.h"

@implementation UIColor (FTColor)
/**
 *  十六进制RGB颜色
 *
 *  @param hex 十六进制符号 eg.:0x0000ff
 *
 *  @return Color
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    return [UIColor colorWithRGBHex:hex alpha:1.0f];
}

/**
 *  十六进制RGB颜色
 *
 *  @param hex   十六进制符号 eg.:0x00ff00
 *  @param alpha 透明度
 *
 *  @return Color
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:alpha];
}

//随机颜色
+ (UIColor *)colorWithRandomColor {
    return [UIColor colorWithRed:(CGFloat)random() / (CGFloat)RAND_MAX
                           green:(CGFloat)random() / (CGFloat)RAND_MAX
                            blue:(CGFloat)random() / (CGFloat)RAND_MAX
                           alpha:1.0f];
}

//项目中常用的边框颜色
+ (UIColor *)borderColor {
    return [UIColor colorWithRGBHex:0Xd8d8d8];
}

//项目中常用的分割线颜色
+ (UIColor *)lineColor {
    return [UIColor colorWithRGBHex:0Xd8d8d8];
}

@end
