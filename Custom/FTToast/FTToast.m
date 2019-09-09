//
//  FTToast.m
//  FTTemplate
//
//  Created by 史超 on 2018/11/28.
//  Copyright © 2018年 史超. All rights reserved.
//

#import "FTToast.h"
#import "FTCommonMacro.h"

@implementation FTToast

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static FTToast *install;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        install = [super allocWithZone:zone];
    });
    return install;
}

- (UILabel *)laebl {
    if (!_laebl) {
        _laebl = [[UILabel alloc] init];
        _laebl.textAlignment = NSTextAlignmentCenter;
        _laebl.textColor = [UIColor whiteColor];
        _laebl.font = self.font?self.font:[UIFont systemFontOfSize:15];
        _laebl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _laebl.cornerRadius = 3;
        _laebl.numberOfLines = 3;
    }
    return _laebl;
}

+ (FTToast *)share {
    return [[FTToast alloc] init];
}

+ (void)showToastWithString:(NSString *)string {
    
    if (string.length==0) {
        return;
    }
    
    UILabel *label = [FTToast share].laebl;
    if (label.superview) { //如果已经存在添加的
        return;
    }
    
    CGSize size = [NSString sizeWithText:string font:[FTToast share].font?[FTToast share].font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-60, 80)];
    label.frame = CGRectMake(30, SCREENHEIGHT-TabBarHeight-(size.height+6)-30, size.width+15, size.height+6);
    label.text = string;
    [WINDOW addSubview:label];
    label.centerX = WINDOW.centerX;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([FTToast share].showTime?[FTToast share].showTime:1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
    
}

@end
