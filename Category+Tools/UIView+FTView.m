//
//  UIView+CustomView.m
//  QCMVVM
//
//  Created by 史超 on 2018/11/15.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "UIView+FTView.h"
#import "FTCommonMacro.h"
static char const * const requestFailedViewKey = "requestFailedViewKey";
static char const * const keyAction =       "action";

@implementation UIView (FTView)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}


- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = (CGRect){
        .origin.x = self.x,
        .origin.y = self.y,
        .size.width =  size.width,
        .size.height = size.height
    };
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = (CGRect){
        .origin.x = origin.x,
        .origin.y = origin.y,
        .size.width =  self.width,
        .size.height = self.height
    };
    
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = (CGRect){
        .origin.x = self.x,
        .origin.y = bottom - self.height,
        .size.width =  self.width,
        .size.height = self.height
    };
    
    self.frame = frame;
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = (CGRect){
        .origin.x = right - self.width,
        .origin.y = self.y,
        .size.width =  self.width,
        .size.height = self.height
    };
    
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint origin = (CGPoint){
        .x = centerX,
        .y = self.center.y
    };
    
    self.center = origin;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint origin = (CGPoint){
        .x = self.center.x,
        .y = centerY
    };
    
    self.center = origin;
}

- (CGFloat)borderWidth {
    return self.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth<0?0:borderWidth;
}

- (UIColor *)borderColor {
    return self.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)cornerRadius {
    return self.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}


- (UIView *(^)(CGRect frame))sc_frame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(UIColor *color))sc_color {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIView *(^)(CGFloat value))sc_cornerRadius{
    return ^(CGFloat value) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = value;
        return self;
    };
}

- (void)addRandomColorBorder {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRandomColor].CGColor;
}

- (void)addClickEvent:(id)target action:(SEL)action {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:gesture];
}

- (void)moveBy:(CGPoint)point {
    CGPoint newcenter = self.center;
    newcenter.x += point.x;
    newcenter.y += point.y;
    self.center = newcenter;
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)btnClick {
//    NSLog(@"6666");
   void(^ac)(void) = objc_getAssociatedObject(self, &keyAction);
    if (ac) {
       ac();
    }else {
        NSLog(@"有错！！！！有错！！！！有错！！！！有错！！！！有错！！！！");
    }
    
}

- (void)showNetworkRequestFailedView:(void (^)(void))action {
    
    if (self.bounds.size.width<80 || self.bounds.size.height < 140) {
        NSLog(@"控件太小了！");
        return;
    }
    UIView *view = objc_getAssociatedObject(self, &requestFailedViewKey);

    if (!view) {  //如果没有view 再创建
        view = [[UIView alloc] initWithFrame:self.bounds];
        //给分类添加属性
        objc_setAssociatedObject(self, &requestFailedViewKey, view, OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self, &keyAction, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
    }else { //有的话 就加到上面 推到最前面
        [self addSubview:view];
        [self bringSubviewToFront:view];
        return;
    }

    if ([view.backgroundColor isEqual:[UIColor clearColor]]) { //如果是透明色
        view.backgroundColor =  RGBA(246, 246, 246, 1);
    }else
        view.backgroundColor = self.backgroundColor;  //设置背景颜色 不然会透明  看到下边内容


    
    
    UIImageView *rfImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
//    rfImage.image = imageWithName(@"request_failed_image");
    
    rfImage.image = [UIImage imageNamed:@"request_failed_image" inBundle:[NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FTCommonBundle.bundle"]] compatibleWithTraitCollection:nil];
    
    [view addSubview:rfImage];
    rfImage.center = CGPointMake(self.centerX, self.centerY-80);

    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rfImage.frame)+20, self.width, 60)];
    desLabel.numberOfLines = 2;
    desLabel.textColor = [UIColor grayColor];
    [desLabel setText:@"网络请求失败\n请检查您的网络" lineSpacing:8];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.font = [UIFont FTFont:14];
    [view addSubview:desLabel];

    UIButton *rfButton = [UIButton buttonWithTitle:@"重新加载" andAction:nil];
    [rfButton  addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    rfButton.titleLabel.font = [UIFont FTFont:15];
    rfButton.frame = CGRectMake(0, CGRectGetMaxY(desLabel.frame)+20, 100, 35);
    rfButton.centerX = self.centerX;
    [rfButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rfButton.layer.cornerRadius = 4;
    rfButton.borderColor = [UIColor borderColor];
    rfButton.borderWidth = 1;

    [view addSubview:rfButton];
    
    [self addSubview:view];
}

- (void)removeNetworkRequestFailedView {
    __block UIView *view = objc_getAssociatedObject(self, &requestFailedViewKey);
    if (view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
            view = nil;
//            objc_removeAssociatedObjects(self); //移除分类添加的属性  慎用！也会移除别的分类添加的属性 
        });
    }
}

// 从 XIB 中加载视图
+ (instancetype)sc_loadViewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (BOOL)isShowOnWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect newRect = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    BOOL isIntersects =  CGRectIntersectsRect(newRect, winBounds);
    if (self.hidden != YES && self.alpha >0.01 && self.window == keyWindow && isIntersects) {
        return YES;
    }else{
        return NO;
    }
}

- (UIViewController *)parentController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (UIView *)settingView:(void(^)(UIView *scView))make {
    make(self);
    return self;
}

@end
