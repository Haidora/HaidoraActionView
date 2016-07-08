//
//  HDActionView.m
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDActionView.h"

@interface HDActionView ()

@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;

@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation HDActionView

#pragma mark
#pragma mark Init

+ (HDActionView *)sharedInstance
{
    static HDActionView *actionView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionView = [[HDActionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        actionView.autoresizingMask =
            UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    });
    return actionView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _menus = [NSMutableArray array];
        _tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)dealloc
{
    [self removeGestureRecognizer:_tapGesture];
}

#pragma mark
#pragma mark Action

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    CGPoint touchPoint = [tapGesture locationInView:self];
    HDBaseMenu *menu = [self.menus lastObject];
    if (!CGRectContainsPoint(menu.frame, touchPoint))
    {
        [[HDActionView sharedInstance] dismissMenu:menu animation:YES completionBlock:nil];
    }
}

- (void)setMenu:(HDBaseMenu *)menu animation:(BOOL)animated
{
    if (![self superview])
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window)
            window = [[UIApplication sharedApplication].windows lastObject];
        [window addSubview:self];
    }
    [self.menus makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.menus addObject:menu];
    [self addSubview:menu];

    // config menu
    menu.popupPosition = [[HDActionView sharedInstance] popupPosition];
    if (animated && self.menus.count == 1)
    {
        [CATransaction begin];

        [CATransaction setAnimationDuration:0.2];
        [CATransaction
            setAnimationTimingFunction:[CAMediaTimingFunction
                                           functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
        [menu.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
        [CATransaction commit];
    }
}

- (void)dismissMenu:(HDBaseMenu *)menu
          animation:(BOOL)animated
    completionBlock:(void (^)(void))completionBlock
{
    if ([self superview])
    {
        [self.menus removeObject:menu];
        if (animated && self.menus.count == 0)
        {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.2];
            [CATransaction
                setAnimationTimingFunction:[CAMediaTimingFunction
                                               functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setCompletionBlock:^{
                [self removeFromSuperview];
                [menu removeFromSuperview];
                if (completionBlock)
                {
                    completionBlock();
                }
            }];
            [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
            [menu.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
            [CATransaction commit];
        }
        else
        {
            [menu removeFromSuperview];
            HDBaseMenu *topMenu = self.menus.lastObject;
            [self addSubview:topMenu];
            [topMenu layoutIfNeeded];
            topMenu.frame = (CGRect){0, self.bounds.size.height - topMenu.bounds.size.height,
                                     topMenu.bounds.size};
            if (completionBlock)
            {
                completionBlock();
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    HDBaseMenu *menu = [self.menus firstObject];
    if (menu)
    {
        [menu setNeedsLayout];
        [menu setNeedsDisplay];
    }
}
#pragma mark
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.tapGesture])
    {
        CGPoint point = [gestureRecognizer locationInView:self];
        HDBaseMenu *menu = [self.menus lastObject];
        if (CGRectContainsPoint(menu.frame, point))
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark
#pragma mark Animation

/**
 *  背景变暗的动画
 *
 */
- (CAAnimation *)dimingAnimation
{
    if (nil == _dimingAnimation)
    {
        CABasicAnimation *opacityAnimation =
            [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[UIColor colorWithWhite : 0.0 alpha : 0.0].CGColor;
        opacityAnimation.toValue = (id)[UIColor colorWithWhite : 0.0 alpha : 0.4].CGColor;
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (nil == _showMenuAnimation)
    {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];

        CABasicAnimation *scaleAnimation =
            [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];

        CABasicAnimation *positionAnimation =
            [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:@(50.0)];
        [positionAnimation setToValue:@(0.0)];

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@(0.0)];
        [opacityAnimation setToValue:@(1.0)];

        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:
                   @[ rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation ]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (nil == _lightingAnimation)
    {
        CABasicAnimation *opacityAnimation =
            [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)dismissMenuAnimation
{
    if (nil == _dismissMenuAnimation)
    {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];

        CABasicAnimation *scaleAnimation =
            [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@(1.0)];
        [scaleAnimation setToValue:@(0.9)];

        CABasicAnimation *postionAnimation =
            [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [postionAnimation setFromValue:@(0.0)];
        [postionAnimation setToValue:@(50.0)];

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@(1.0)];
        [opacityAnimation setToValue:@(0.0)];

        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:
                   @[ rotateAnimation, scaleAnimation, opacityAnimation, postionAnimation ]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}

#pragma mark
#pragma mark Public

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle
            selectedHandle:(HDActionHandle)handler
{
    [HDActionView showAlertWithTitle:title
                             message:message
                     leftButtonTitle:buttonTitle
                    rightButtonTitle:nil
                      selectedHandle:handler];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
           leftButtonTitle:(NSString *)leftTitle
          rightButtonTitle:(NSString *)rightTitle
            selectedHandle:(HDActionHandle)handler
{
    HDAlertMenu *menu = [[HDAlertMenu alloc] initWithTitle:title
                                                   message:message
                                              buttonTitles:leftTitle, rightTitle, nil];
    menu.actionHandle = ^(NSInteger index, HDBaseMenu *menu) {
        [[HDActionView sharedInstance] dismissMenu:menu
                                         animation:YES
                                   completionBlock:^{
                                       if (handler)
                                       {
                                           handler(index);
                                       }
                                   }];
    };

    [[HDActionView sharedInstance] setMenu:menu animation:YES];
}

+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
            selectedHandle:(HDActionHandle)handle
{
    [HDActionView showSheetWithTitle:title
                          itemImages:nil
                          itemTitles:itemTitles
                           subTitles:nil
                      selectedHandle:handle];
}

+ (void)showSheetWithTitle:(NSString *)title
                itemImages:(NSArray *)itemImageNames
                itemTitles:(NSArray *)itemTitles
                 subTitles:(NSArray *)subTitles
            selectedHandle:(HDActionHandle)handle
{
    HDSheetMenu *menu = [[HDSheetMenu alloc] initWithTitle:title
                                                itemImages:itemImageNames
                                                itemTitles:itemTitles
                                                 subTitles:subTitles];
    menu.actionHandle = ^(NSInteger index, HDBaseMenu *menu) {
        [[HDActionView sharedInstance] dismissMenu:menu
                                         animation:YES
                                   completionBlock:^{
                                       if (handle)
                                       {
                                           handle(index);
                                       }
                                   }];
    };

    [[HDActionView sharedInstance] setMenu:menu animation:YES];
}

@end
