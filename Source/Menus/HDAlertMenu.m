//
//  HDAlertMenu.m
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDAlertMenu.h"

#define kButtonHeight 44

#pragma mark
#pragma mark HDBaseButton

@interface HDBaseButton : UIButton

@end

@implementation HDBaseButton

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        UIColor *highlighted = [[HDAlertMenu appearance] buttonHighlightedColor];
        if (highlighted)
        {
            self.backgroundColor = highlighted;
        }
        else
        {
            self.backgroundColor = [UIColor lightGrayColor];
        }
    }
    else
    {
        UIColor *normaled = [[HDAlertMenu appearance] buttonHighlightedColor];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            if (normaled)
            {
                self.backgroundColor = normaled;
            }
            else
            {
                self.backgroundColor = [UIColor clearColor];
            }
        });
    }
}

@end

#pragma mark
#pragma mark HDAlertMenu

@interface HDAlertMenu ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *hLineView;
@property (nonatomic, strong) UIView *vLineView;
@property (nonatomic, strong) NSMutableArray *actionButtons;

@end

@implementation HDAlertMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = nil;
        _messageLabel = nil;
        _actionButtons = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSString *)buttonTitles, ...
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self)
    {
        NSMutableArray *actionButtonTitles = [NSMutableArray array];
        if (buttonTitles)
        {
            [actionButtonTitles addObject:buttonTitles];
            id eachObj;
            va_list argumentList;
            va_start(argumentList, buttonTitles);
            while ((eachObj = va_arg(argumentList, id)))
            {
                [actionButtonTitles addObject:eachObj];
            }
            va_end(argumentList);
        }
        if (actionButtonTitles.count > 2)
        {
            [actionButtonTitles removeObjectsInRange:NSMakeRange(2, actionButtonTitles.count)];
        }
        [self setupWithTitle:title message:message actionTitles:actionButtonTitles];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title
               message:(NSString *)message
          actionTitles:(NSArray *)actionTitles
{
    if (title)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
    }
    if (message)
    {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = message;
        [self addSubview:_messageLabel];
    }

    [actionTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = obj;
        HDBaseButton *actionButton = [HDBaseButton buttonWithType:UIButtonTypeCustom];
        actionButton.tag = idx;
        actionButton.clipsToBounds = YES;
        actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [actionButton setTitleColor:[UIColor colorWithRed:0.024 green:0.490 blue:0.996 alpha:1]
                           forState:UIControlStateNormal];
        [actionButton setTitle:title forState:UIControlStateNormal];
        [actionButton addTarget:self
                         action:@selector(tapAction:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionButton];
        [self.actionButtons addObject:actionButton];
    }];
    self.hLineView = [[UIView alloc] initWithFrame:(CGRect){0, 0, self.bounds.size.width, 0.5}];
    self.hLineView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.hLineView];

    self.vLineView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0.5, kButtonHeight}];
    self.vLineView.backgroundColor = [UIColor grayColor];
}

- (void)tapAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    if ([sender isKindOfClass:[UIButton class]] && self.actionHandle)
    {
        NSInteger tag = [(UIButton *)sender tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ weakSelf.actionHandle(tag, weakSelf); });
    }
}

#pragma mark
#pragma mark Renders
- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect mainRect = [[self superview] bounds];
    CGFloat margin = 0;

    switch (self.popupPosition)
    {
    case HDActionViewPopupPositionMiddle:
    {
        static CGFloat perMargin = 0.1;
        margin = CGRectGetWidth(mainRect) * perMargin;
        break;
    }
    case HDActionViewPopupPositionBottom:
    default:
        break;
    }

    CGFloat maxWidth = CGRectGetWidth(mainRect) - 2 * margin;

    CGFloat height = 0;
    CGFloat title_top_margin = 0;
    CGFloat message_top_margin = 0;
    CGFloat message_bottom_margin = self.messageLabel.text ? 15 : 0;

    height += title_top_margin;
    if (self.titleLabel)
    {
        if (self.titleColor)
        {
            _titleLabel.textColor = self.titleColor;
        }
        if (self.titleFont)
        {
            _titleLabel.font = self.titleFont;
        }
        if (self.titleBackgroundColor)
        {
            _titleLabel.backgroundColor = self.titleBackgroundColor;
        }
        self.titleLabel.frame = (CGRect){0, height, maxWidth, 50};
        height += self.titleLabel.bounds.size.height;
    }

    height += message_top_margin;
    if (self.messageLabel)
    {
        if (self.messageColor)
        {
            _messageLabel.textColor = self.messageColor;
        }
        if (self.messageFont)
        {
            _messageLabel.font = self.messageFont;
        }
        if (self.messageBackgroundColor)
        {
            _messageLabel.backgroundColor = self.messageBackgroundColor;
        }
        CGSize size = CGSizeMake(maxWidth, INFINITY);
        size = [self.messageLabel sizeThatFits:size];
        self.messageLabel.frame = (CGRect){0, height, maxWidth, size.height};
        height += size.height;
    }
    height += message_bottom_margin;

    self.hLineView.frame = (CGRect){0, height, maxWidth, self.hLineView.bounds.size.height};
    float btn_y = height;
    for (int i = 0; i < self.actionButtons.count; i++)
    {
        UIButton *button = self.actionButtons[i];
        if (self.buttonTextColor)
        {
            [button setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        }
        if (self.buttonFont)
        {
            button.titleLabel.font = self.buttonFont;
        }
        if (self.buttonNormalColor)
        {
            button.backgroundColor = self.buttonNormalColor;
        }
        button.frame =
            (CGRect){i * maxWidth / 2, btn_y, maxWidth / self.actionButtons.count, kButtonHeight};
        if (i == 0)
        {
            height += 44;
        }
        if (self.actionButtons.count == 2 && i == 0)
        {
            self.vLineView.frame = (CGRect){button.frame.origin.x + button.frame.size.width,
                                            button.frame.origin.y, 0.5, kButtonHeight};
            [self addSubview:self.vLineView];
        }
    }
    CGRect rect;

    switch (self.popupPosition)
    {
    case HDActionViewPopupPositionMiddle:
    {
        rect = (CGRect){margin, (CGRectGetHeight(mainRect) - height) / 2,
                        CGRectGetWidth(mainRect) - margin * 2, height};
        break;
    }
    case HDActionViewPopupPositionBottom:
    {
        rect = (CGRect){margin, (CGRectGetHeight(mainRect) - height),
                        CGRectGetWidth(mainRect) - margin * 2, height};
        break;
    }
    default:
        break;
    }
    if ((self.frame.origin.x != rect.origin.x) || (self.frame.origin.y != rect.origin.y) ||
        (self.frame.size.width != rect.size.width) || (self.frame.size.height != rect.size.height))
    {
        self.frame = rect;
    }
}

@end
