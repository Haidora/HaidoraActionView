//
//  HDBaseMenu.m
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDBaseMenu.h"

@implementation HDBaseMenu

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _roundedCorner = YES;
}

#pragma mark
#pragma mark Setter

- (void)setRoundedCorner:(BOOL)roundedCorner
{
    _roundedCorner = roundedCorner;
    [self setNeedsDisplay];
}

#pragma mark
#pragma mark Render

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_roundedCorner)
    {
        UIRectCorner rectCorner = UIRectCornerAllCorners;
        switch (_popupPosition)
        {
        case HDActionViewPopupPositionMiddle:
        {
            rectCorner = UIRectCornerAllCorners;
            break;
        }
        case HDActionViewPopupPositionBottom:
        {
            rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        }
        default:
            break;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
    else
    {
        self.layer.mask = nil;
    }
}

@end
