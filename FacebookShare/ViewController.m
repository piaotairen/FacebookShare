//
//  ViewController.m
//  FacebookShare
//
//  Created by Cobb on 16/6/6.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "ViewController.h"
#import "LSShareContentView.h"


@interface ViewController () <LSShareDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareButtonClick:(id)sender {
    NSLog(@"shareButtonClick");
    
    [[LSShareContentView sharedView] showWithCompletion:^(){
        NSLog(@"显示分享视图");
    }];
    [LSShareContentView sharedView].delegate = self;
}

#pragma mark - 分享
/**
 * @brief 点击了分享按钮（Facebook、twitter、Instagram）
 */
- (void)shareWithType:(LSShareType)type
{
    [[LSLiveShareHelper defaultHelper]shareWithType:type Content:@"测试分享" Controller:self];
}

@end
