//
//  LSShareContentView.h
//  FacebookShare
//
//  Created by Cobb on 16/6/6.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSLiveShareHelper.h"

typedef void(^LSShowCompletion)(void);//显示成功的回调
typedef void(^LSDismissCompletion)(void);//隐藏成功的回调

@protocol LSShareDelegate <NSObject>
@optional
/**
 * @brief 点击了分享按钮（Facebook、twitter、Instagram）
 */
- (void)shareWithType:(LSShareType)type;

@end

/**
 * 分享弹出视图
 */
@interface LSShareContentView : UIView

/**
 * 分享按钮父视图
 */
@property (nonatomic,readonly,strong) UIView *shareButtonContentView;
/**
 * 取消按钮
 */
@property (nonatomic,readonly,strong) UIButton *cancelButton;
/**
 * 分享按钮点击协议
 */
@property (nonatomic,readwrite,weak) id <LSShareDelegate>delegate;

/**
 * @breif 获取分享视图实例
 */
+ (instancetype)sharedView;
/**
 * @breif 默认的显示视图方法
 */
- (void)show;
/**
 * @breif 显示视图方法带回调
 */
- (void)showWithCompletion:(LSShowCompletion)completion;
/**
 * @breif 隐藏视图
 */
- (void)dismiss;
/**
 * @breif 隐藏视图方法带回调
 */
- (void)dismissWithCompletion:(LSDismissCompletion)completion;

@end
