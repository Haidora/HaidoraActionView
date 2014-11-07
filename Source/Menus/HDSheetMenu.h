//
//  HDSheetMenu.h
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDBaseMenu.h"

@interface HDSheetMenu : HDBaseMenu

/**
 *  TitleLable Appearance
 */
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleBackgroundColor UI_APPEARANCE_SELECTOR;

- (instancetype)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles;

- (instancetype)initWithTitle:(NSString *)title
                   itemImages:(NSArray *)itemImageNames
                   itemTitles:(NSArray *)itemTitles
                    subTitles:(NSArray *)subTitles;

@end
