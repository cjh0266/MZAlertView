//
//  MZAlertView.m
//  LLY
//
//  Created by 崔俊红 on 15/8/13.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZAlertView.h"
#define MZALERTBUTTONCOLOR [UIColor colorWithRed:0.980 green:0.988 blue:0.996 alpha:1.000]
#define MZALERTBACKCOLOR [UIColor colorWithWhite:0.827 alpha:1.000];
#define MZTOASTFONTCOLOR [UIColor colorWithRed:0.561 green:0.565 blue:0.573 alpha:1.000]
#define MZTOASTBACKCOLOR [UIColor colorWithRed:0.988 green:0.980 blue:0.996 alpha:1.000]
 
@interface MZAlertAction ()
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) void(^handler)(MZAlertAction *);
@end
@implementation MZAlertAction
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(MZAlertAction *))handler
{
    MZAlertAction *action = [[MZAlertAction alloc]init];
    action.title = title;
    action.handler = handler;
    return action;
}
@end

@interface MZAlertView ()
@property (assign, nonatomic) MZAlertViewStyle preferredStyle;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UIView *dimView;
@end

@implementation MZAlertView

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(MZAlertViewStyle)preferredStyle
{
    MZAlertView *alertView = [[MZAlertView alloc]init];
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    alertView.preferredStyle = preferredStyle;
    alertView.title = title;
    alertView.message = message;
    alertView.actions = [NSMutableArray array];
    
    alertView.dimView = [[UIView alloc]init];
    alertView.dimView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
    if(preferredStyle == MZAlertViewStyleSheet){
        alertView.backgroundColor =  MZALERTBACKCOLOR;
        alertView.dimView.userInteractionEnabled = YES;
        [alertView.dimView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:alertView action:@selector(dimiss)]];
    }
    alertView.dimView.alpha = 0;
    return alertView;
}

- (void)addAction:(MZAlertAction *)action
{
    [self.actions addObject:action];
}

- (void)show
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    _dimView.translatesAutoresizingMaskIntoConstraints = NO;
    [win addSubview:_dimView];
    [win addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dimView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_dimView)]];
    [win addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dimView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_dimView)]];
    switch (self.preferredStyle) {
        case MZAlertViewStyleAlert:
            [self showAlert];
            break;
        case MZAlertViewStyleSheet:
            [self showSheet];
            break;
        default:
            break;
    }
}

- (void)dimiss
{
    if (self.preferredStyle == MZAlertViewStyleAlert) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
            [UIView animateWithDuration:0.1 animations:^{
                _dimView.alpha = 0;
            }completion:^(BOOL finished) {
                [_dimView removeFromSuperview];
            }];
        }];
    } else if(self.preferredStyle == MZAlertViewStyleSheet) {
        [UIView animateWithDuration:0.3 animations:^{
            _dimView.alpha = 0;
            UIWindow *win = [UIApplication sharedApplication].keyWindow;
            for (NSLayoutConstraint *constraint in win.constraints) {
                if (constraint.secondItem==self && constraint.secondAttribute == NSLayoutAttributeBottom) {
                    constraint.constant = -[self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                }
            }
            [self layoutIfNeeded];
            [self setNeedsDisplay];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_dimView removeFromSuperview];
        }];
    }
}
 
- (void)showAlert
{
    //布局
    UIView *wrapContentView = [[UIView alloc]init];
    wrapContentView.translatesAutoresizingMaskIntoConstraints = NO;
    wrapContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:wrapContentView];

    UIView *wrapButtonView = [[UIView alloc]init];
    wrapButtonView.backgroundColor = MZALERTBACKCOLOR;
    wrapButtonView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:wrapButtonView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wrapContentView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(wrapContentView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wrapButtonView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(wrapButtonView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrapContentView][wrapButtonView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(wrapContentView,wrapButtonView)]];
 
    __block UIView *preView = nil;
    //标题
    if (_title && [_title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 60;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleLabel.text = _title;
        
        UIView *line = [[UIView alloc]init];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.310];
        [wrapContentView addSubview:line];
 
        [wrapContentView addSubview:titleLabel];
        [wrapContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel(line)]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,line)]];
        [wrapContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel(35)][line(0.5)]" options:NSLayoutFormatAlignAllLeading|NSLayoutFormatAlignAllTrailing metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,line)]];
        preView = line;
    }
    //内容
    if (_message) {
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.font = [UIFont systemFontOfSize:14.0f];
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.text = _message;
        
        [wrapContentView addSubview:messageLabel];
        [wrapContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[messageLabel]-10-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
        if (preView) {
            [wrapContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[preView][messageLabel(>=50)]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(messageLabel,preView)]];
        } else {
            [wrapContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[messageLabel(>=50)]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
        }
    }
    //按钮
    if (self.actions && self.actions.count>0) {
        __block UIButton *preBtn = nil;
        [self.actions enumerateObjectsUsingBlock:^(MZAlertAction *action, NSUInteger idx, BOOL *stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tag = idx;
            [btn addTarget:self action:@selector(clickAct:) forControlEvents:UIControlEventTouchUpInside];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            btn.backgroundColor = MZALERTBUTTONCOLOR;
            [btn setTitle:action.title forState:UIControlStateNormal];
            [wrapButtonView addSubview:btn];
            
            [wrapButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0.5)-[btn]-(0.5)-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            [wrapButtonView addConstraint:[NSLayoutConstraint constraintWithItem:wrapButtonView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            if (idx == 0) {
                [wrapButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0.5)-[btn]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            }
            if(idx == _actions.count-1){
                [wrapButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]-(0.5)-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            } 
            if (preBtn) {
                [wrapButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preBtn]-(0.5)-[btn(preBtn)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn,preBtn)]];
            }
            preBtn = btn;
        }];
    }
    //展示组件主视图
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    [win addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[self]-20-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    [win addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:win attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
 
    //动画展示
    self.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        _dimView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
        }completion:nil];
    }];
}

/**
 *  @author 崔俊红, 15-08-13 09:08:37
 *
 *  @brief  弹出类似UISheetView视图
 *  @since v1.0
 */
- (void)showSheet
{
    //布局小组件
    __block UIView *preView = nil;
    //标题
    if (self.title) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        
        [self addSubview:titleLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel(35)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
        preView = titleLabel;
    }
    //按钮
    if (self.actions && self.actions.count>0) {
        [self.actions enumerateObjectsUsingBlock:^(MZAlertAction *action, NSUInteger idx, BOOL *stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tag = idx;
            [btn addTarget:self action:@selector(clickAct:) forControlEvents:UIControlEventTouchUpInside];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            btn.backgroundColor = MZALERTBUTTONCOLOR;
            [btn setTitle:action.title forState:UIControlStateNormal];
            [self addSubview:btn];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[btn]-10-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            if (preView) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[preView]-10-[btn(40)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn,preView)]];
            }else {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[btn(40)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            }
            preView = btn;
        }];
    }
    if (preView) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[preView]-10-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(preView)]];
    }
    
    //展示组件主视图
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    //添加约束
    [win addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLayoutConstraint *bottomLC = [NSLayoutConstraint constraintWithItem:win attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-height];
    [win addConstraint:bottomLC];
    //动画展示
    [UIView animateWithDuration:0.1 animations:^{
        _dimView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            bottomLC.constant = 0;
            [self layoutIfNeeded];
            [self setNeedsDisplay];
        }completion:nil];
    }];
}

#pragma mark - Events Handler

- (void)clickAct:(UIButton*)sender
{
    NSInteger idx = sender.tag;
    if (_actions && _actions.count>idx) {
        MZAlertAction *action = _actions[idx];
        if (action.handler) {
            action.handler(action);
        }
    }
    [self dimiss];
}
@end
