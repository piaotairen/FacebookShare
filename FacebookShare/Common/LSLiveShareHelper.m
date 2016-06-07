//
//  LSLiveShareHelper.m
//  FacebookShare
//
//  Created by Cobb on 16/6/6.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "LSLiveShareHelper.h"
#import "FBSDKShareKit.h"
#import <TwitterKit/TwitterKit.h>
#import "InstagramKit.h"

@interface LSLiveShareHelper () <UIDocumentInteractionControllerDelegate>

/**
 * 持有的视图控制器
 */
@property (nonatomic,readwrite,strong) UIViewController *showViewController;
/**
 * 持有的instagram图片资源
 */
@property (nonatomic,readwrite,strong) UIImage *instagramImage;
/**
 * 持有的DocumentInteractionController
 */
@property (nonatomic,readwrite,strong) UIDocumentInteractionController *documentController;

@end

@implementation LSLiveShareHelper

/**
 * @brief 返回单例
 */
+ (instancetype)defaultHelper
{
    static LSLiveShareHelper *helper = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        helper = [[self alloc]init];
    });
    return helper;
}

/**
 * @brief 分享的方法
 * @param type 分享类型
 * @param content 分享内容
 */
- (void)shareWithType:(LSShareType)type Content:(NSString *)content Controller:(UIViewController *)viewController
{
    NSLog(@"分享内容为  content is %@",content);
    self.showViewController = viewController;
    switch (type) {
        case LSShareTypeFacebook:
            [self facebookShare];
            break;
        case LSShareTypeTwitter:
            [self twitterShare];
            break;
        case LSShareTypeInstagram:
            [self instagramShare];
            break;
    }
}
#pragma mark - 分享接口调用
/**
 * @breif facebook分享
 */
- (void)facebookShare
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
    
    [FBSDKShareDialog showFromViewController:self.showViewController
                                 withContent:content
                                    delegate:nil];
}
/**
 * @breif twitter分享
 */
- (void)twitterShare
{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:@"just setting up my Fabric"];
    [composer setImage:[UIImage imageNamed:@"fabric"]];
    
    // Called from a UIViewController
    [composer showFromViewController:self.showViewController completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}
/**
 * @breif instagram分享
 */
- (void)instagramShare
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    //检查app是否安装
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]){
        NSString *imagePath = [NSString stringWithFormat:@"%@/iamge.igo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]];
        [[NSFileManager defaultManager]removeItemAtPath:imagePath error:nil];
        
        UIImage *localImage = [UIImage imageNamed:@"Icon_Instagram"];
        _instagramImage = [self scaleImage:localImage ToSize:CGSizeMake(612, 524)];
        [UIImagePNGRepresentation(_instagramImage) writeToFile:imagePath atomically:YES];
        NSLog(@"localImage size is %@",NSStringFromCGSize(_instagramImage.size));
        
        _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"file://%@", imagePath]]];
        _documentController.delegate = self;
        _documentController.UTI = @"com.intagram.exclusivegram";
        [_documentController presentOpenInMenuFromRect:self.showViewController.view.frame inView:self.showViewController.view animated:YES];
    }else{
        NSLog (@"Instagram not found");
    }
}

/**
 * @breif 等比例缩放
 */
-(UIImage*)scaleImage:(UIImage *)image ToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1){
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }else{
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
