//
//  UILabel+FTLabel.m
//  FTTemplate
//
//  Created by 史超 on 2018/11/21.
//  Copyright © 2018年 史超. All rights reserved.
//

#import "UILabel+FTLabel.h"

@implementation UILabel (FTLabel)

-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; [paragraphStyle setLineSpacing:lineSpacing];
    //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode]; [paragraphStyle setAlignment:self.textAlignment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text]; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])]; self.attributedText = attributedString;
}

@end
