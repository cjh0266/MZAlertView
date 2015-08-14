//
//  MZAlertView.h
//  LLY
//
//  Created by 崔俊红 on 15/8/13.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MZAlertActionStyle) {
    MZAlertActionStyleDefault = 0,
    MZAlertActionStyleCancel
};

@interface MZAlertAction : NSObject
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(MZAlertAction *action))handler;
@end

typedef NS_ENUM(NSUInteger, MZAlertViewStyle) {
    MZAlertViewStyleAlert,
    MZAlertViewStyleSheet
};

@interface MZAlertView : UIView
@property (strong, nonatomic) NSMutableArray *actions;
/**
 *  @author 崔俊红, 15-08-13 09:08:42
 *
 *  @brief  初化一个Alert对象
 *  @param title          标题
 *  @param message        MZAlertViewStyleAlert 有效
 *  @param preferredStyle 样式
 *  @return Alert对象
 *  @since v1.0
 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString*)message preferredStyle:(MZAlertViewStyle)preferredStyle;
/**
 *  @author 崔俊红, 15-08-14 14:08:52
 *
 *  @brief  添加Action
 *  @param action MZAlertAction
 *  @since v1.0
 */
- (void)addAction:(MZAlertAction*)action;
/**
 *  @author 崔俊红, 15-08-14 14:08:09
 *
 *  @brief  弹出
 *  @since v1.0
 */
- (void)show;
@end