//
//  HDSheetMenu.m
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDSheetMenu.h"

#define kMAX_SHEET_TABLE_HEIGHT 300

@interface HDSheetMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *subItems;

@end

@implementation HDSheetMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _images = [NSArray array];
        _items = [NSArray array];
        _subItems = [NSArray array];

        // title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        // tableView
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_tableView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles
{
    return [self initWithTitle:title itemImages:nil itemTitles:itemTitles subTitles:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                   itemImages:(NSArray *)itemImageNames
                   itemTitles:(NSArray *)itemTitles
                    subTitles:(NSArray *)subTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self)
    {
        _titleLabel.text = title;
        _images = itemImageNames;
        _items = itemTitles;
        _subItems = subTitles;
    }
    return self;
}

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
    CGFloat table_top_margin = 0;
    CGFloat table_bottom_margin = 10;

    height += title_top_margin;
    if (self.titleLabel)
    {
        if (self.titleColor)
        {
            self.titleLabel.textColor = self.titleColor;
        }
        if (self.titleBackgroundColor)
        {
            self.titleLabel.backgroundColor = self.titleBackgroundColor;
        }
        if (self.titleFont)
        {
            self.titleLabel.font = self.titleFont;
        }
        self.titleLabel.frame = (CGRect){0, height, maxWidth, 50};
        height += self.titleLabel.bounds.size.height;
    }

    height += table_top_margin;

    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];

    float contentHeight = self.tableView.contentSize.height;
    if (contentHeight > kMAX_SHEET_TABLE_HEIGHT)
    {
        contentHeight = kMAX_SHEET_TABLE_HEIGHT;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.frame = (CGRect){margin, height, maxWidth, contentHeight};
    height += contentHeight;
    height += table_bottom_margin;
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

#pragma mark
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"ITKAVShhetMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentify];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = _items[indexPath.row];
    if (_images.count > indexPath.row)
    {
        NSString *imageName = self.images[indexPath.row];
        if (![imageName isEqual:[NSNull null]])
        {
            cell.imageView.image = [UIImage imageNamed:imageName];
        }
    }
    if (_subItems.count > indexPath.row)
    {
        NSString *subTitle = self.subItems[indexPath.row];
        if (![subTitle isEqual:[NSNull null]])
        {
            cell.detailTextLabel.text = subTitle;
        }
    }

    return cell;
}

#pragma mark
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subItems.count > 0)
    {
        return 55;
    }
    else
    {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.actionHandle)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       ^{ weakSelf.actionHandle(indexPath.row, weakSelf); });
    }
}

@end
