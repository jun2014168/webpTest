//
//  ViewController.m
//  webpTest
//
//  Created by HxAdmin on 2017/3/3.
//  Copyright © 2017年 HxAdmin. All rights reserved.
//

#import "ViewController.h"
#import <UIImage+WebP.h>
#import <UIImageView+WebCache.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showWebpImageOnUIImageView];
    
//    [self loadWebpHTML];
}


/**
 在imageView上显示 webp 格式图片
 */
- (void)showWebpImageOnUIImageView{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    
    // 加载本地 webp 格式图片
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"animated-gif-0" ofType:@"webp"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    imgV.image = [UIImage sd_imageWithWebPData:data];
    
    // 直接加载网络 webp 格式图片
    //[imgV sd_setImageWithURL:[NSURL URLWithString:@"https://p.upyun.com/demo/webp/webp/animated-gif-0.webp"]];
    [self.view addSubview:imgV];
}

/**
 加载webp.html
 */
- (void)loadWebpHTML{
    
    NSURL *requestUrl = [NSURL URLWithString:@"https://www.upyun.com/webp.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    [self.webVIew loadRequest:request];
}

@end
