//
//  LSLiveShareHelper.h
//  FacebookShare
//
//  Created by Cobb on 16/6/6.
//  Copyright © 2016年 Cobb. All rights reserved.
//

/**
 * 分享的帮助类
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LSShareType) {
    LSShareTypeFacebook = 0,
    LSShareTypeTwitter = 1,
    LSShareTypeInstagram = 2,
};

@interface LSLiveShareHelper : NSObject

/**
 * @brief 返回单例
 */
+ (instancetype)defaultHelper;

/**
 * @brief 分享的方法
 * @param type 分享类型
 * @param content 分享内容
 * @param viewController 分享视图所在的视图控制器
 */
- (void)shareWithType:(LSShareType)type Content:(NSString *)content Controller:(UIViewController *)viewController;

/**
 * @breif facebook分享
 */
- (void)facebookShare;
/**
 * @breif twitter分享
 */
- (void)twitterShare;
/**
 * @breif instagram分享
 */
- (void)instagramShare;

@end
