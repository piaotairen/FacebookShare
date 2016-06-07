//
//  LSLiveShareContent.h
//  FacebookShare
//
//  Created by Cobb on 16/6/7.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 分享的内容整合类
 */
@interface LSLiveShareContent : NSObject

/**
 * 分享的标题
 */
@property (nonatomic, copy) NSString *contentTitle;
/**
 * 分享的内容
 */
@property (nonatomic, copy) NSString *contentDescription;

/**
 * 分享的图片Url
 */
@property (nonatomic, copy) NSURL *imageURL;
/**
 * 分享的图片资源
 */
@property (nonatomic, copy) UIImage *shareImage;
/**
 * 分享的链接link
 */
@property (nonatomic, copy) NSURL *linkURL;

@end
