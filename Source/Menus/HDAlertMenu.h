//
//  HDAlertMenu.h
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDBaseMenu.h"

@interface HDAlertMenu : HDBaseMenu

@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleBackgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *messageColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageBackgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *buttonTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *buttonNormalColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *buttonHighlightedColor UI_APPEARANCE_SELECTOR;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSString *)buttonTitles, ...;

@end
