//
//  FTTextField.m
//  FTTemplate
//
//  Created by 史超 on 2019/2/13.
//  Copyright © 2019年 史超. All rights reserved.
//

#import "FTTextField.h"

@implementation FTTextField

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (range.length == 1 && string.length == 0) {//删除
        return YES;
    }
    if (self.text.length + string.length > self.maxLength) { //长度大于最大限制
        return NO;
    }
        return YES;
    
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    [self setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderTextFont:(UIFont *)placeholderTextFont {
    _placeholderTextFont = placeholderTextFont;
    [self setValue:placeholderTextFont forKeyPath:@"_placeholderLabel.font"];
}


@end
