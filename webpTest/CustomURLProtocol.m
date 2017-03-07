//
//  CustomURLProtocol.m
//  webpTest
//
//  Created by HxAdmin on 2017/3/6.
//  Copyright © 2017年 HxAdmin. All rights reserved.
//

#import "CustomURLProtocol.h"
#import <UIImage+WebP.h>
#import <UIImage+GIF.h>
#import <UIImage+MultiFormat.h>

static NSString *urlProtocolHandleKey = @"URLHasHandle";

@interface CustomURLProtocol()<NSURLSessionDataDelegate,NSURLSessionDelegate>
@property (nonatomic,strong) NSURLSession *session;
@end

@implementation CustomURLProtocol

#pragma mark 初始化请求

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:urlProtocolHandleKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

#pragma mark 通信协议内容实现

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:urlProtocolHandleKey inRequest:mutableReqeust];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    [[self.session dataTaskWithRequest:mutableReqeust] resume];
    
}

- (void)stopLoading
{
    [self.session invalidateAndCancel];
}

#pragma mark dataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSData *transData = data;
    
    if ([dataTask.currentRequest.URL.absoluteString hasSuffix:@"webp"]) {
        //采用 SDWebImage 的转换方法
        UIImage *imgData = [UIImage sd_imageWithWebPData:data];
        transData = UIImageJPEGRepresentation(imgData, 1.0f);
    }
    
    [self.client URLProtocol:self didLoadData:transData];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    
    if (error) {
        
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        
        [self.client URLProtocolDidFinishLoading:self];
    }
    
}
@end
