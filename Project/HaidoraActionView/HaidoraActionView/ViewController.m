//
//  ViewController.m
//  HaidoraActionView
//
//  Created by DaiLingChi on 14-11-7.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "ViewController.h"
#import "HDActionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender
{
    [[HDActionView sharedInstance] setPopupPosition:HDActionViewPopupPositionBottom];
    //    [HDActionView showAlertWithTitle:@"标题"
    //                             message:@"内容"
    //                     leftButtonTitle:@"菜单1"
    //                    rightButtonTitle:@"菜单2"
    //                      selectedHandle:^(NSInteger index) { NSLog(@"%ld", index); }];
    [HDActionView showSheetWithTitle:@"菜单"
                          itemTitles:@[ @"sdfdsf", @"dfdf", @"dfdsf", @"fds" ]
                      selectedHandle:^(NSInteger index) { NSLog(@"%ld", (long)index); }];
}
@end
