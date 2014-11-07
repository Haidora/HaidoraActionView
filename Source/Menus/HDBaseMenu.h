//
//  HDBaseMenu.h
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HDActionHandle)(NSInteger index);

typedef NS_ENUM(NSInteger, HDActionViewPopupPosition)
{
    HDActionViewPopupPositionMiddle = 0,
    HDActionViewPopupPositionBottom
};

@interface HDBaseMenu : UIView

@property (nonatomic, assign) BOOL roundedCorner;
@property (nonatomic, assign) HDActionViewPopupPosition popupPosition;
@property (nonatomic, copy) void (^actionHandle)(NSInteger index, HDBaseMenu *menu);

@end