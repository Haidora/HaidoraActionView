//
//  HDActionView.h
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAlertMenu.h"
#import "HDSheetMenu.h"

@interface HDActionView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) HDActionViewPopupPosition popupPosition;

+ (HDActionView *)sharedInstance;

/**
 *  弹出提示菜单
 *
 *  @param title       标题
 *  @param message     消息
 *  @param buttonTitle 菜单
 *  @param handler     回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle
            selectedHandle:(HDActionHandle)handler;

/**
 *  弹出提示菜单
 *
 *  @param title       标题
 *  @param message     消息
 *  @param leftTitle   第一个菜单
 *  @param rightTitle  第二个菜单
 *  @param handler     回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
           leftButtonTitle:(NSString *)leftTitle
          rightButtonTitle:(NSString *)rightTitle
            selectedHandle:(HDActionHandle)handler;

/**
 *  弹出列表菜单
 *
 *  @param title      标题
 *  @param itemTitles 列表集合
 *  @param handle     回调
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
            selectedHandle:(HDActionHandle)handler;

/**
 *  弹出列表菜单
 *
 *  @param title          标题
 *  @param itemImageNames 图片集合
 *  @param itemTitles     列表集合
 *  @param subTitles      子列表集合
 *  @param handle         回调
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemImages:(NSArray *)itemImageNames
                itemTitles:(NSArray *)itemTitles
                 subTitles:(NSArray *)subTitles
            selectedHandle:(HDActionHandle)handler;
@end
