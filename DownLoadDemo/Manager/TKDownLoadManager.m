//
//  TKDownLoadManager.m
//  DownLoadDemo
//
//  Created by 奥那 on 2018/8/13.
//  Copyright © 2018年 奥那. All rights reserved.
//

#import "TKDownLoadManager.h"
#import <AFNetworking.h>
#import "TKFileUtil.h"

@implementation TKDownLoadManager

+(instancetype)sharedInstance{
    static TKDownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKDownLoadManager alloc]init];
    });
    return manager;
}

/**
 *  下载文件
 *
 *  @param downloadURL  下载链接
 *  @param faliure 错误信息
 */
+(void)downloadURL:(NSString *) downloadURL progress:(void (^)(NSProgress *downloadProgress))progress destination:(void (^)(NSURL *targetPath))destination failure:(void(^)(NSError *error))faliure{

    //1.创建管理者
    AFHTTPSessionManager *manage  = [AFHTTPSessionManager manager];
    
    //2.下载文件
    /*
     第一个参数：请求对象
     第二个参数：下载进度
     第三个参数：block回调，需要返回一个url地址，用来告诉AFN下载文件的目标地址
     targetPath：AFN内部下载文件存储的地址，tmp文件夹下
     response：请求的响应头
     返回值：文件应该剪切到什么地方
     第四个参数：block回调，当文件下载完成之后调用
     response：响应头
     filePath：文件存储在沙盒的地址 == 第三个参数中block的返回值
     error：错误信息
     */
//    NSString *keyStr = [NSString stringWithFormat:@"?systemId=%@",SystemID];
    NSString *url = @"http://192.168.100.236:7777/image-service/common/file_get?systemId=dataPlatform&key=1535443588689913.jpg";

    NSString *filePath = url;
    
//    NSString *filePath = @"";
//    if (@available(iOS 9.0, *)) {
//        filePath = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
//    }else{
//        filePath=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
    //2.1 创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: filePath]];

    NSURLSessionDownloadTask *downloadTask = [manage downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {//进度
        
        if (downloadProgress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [self getFilePathWith:downloadURL];
        
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullPath];
        
        return filePathUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        
        
        if (error) {
            faliure(error);
        }
        
        
        if(filePath){
            
            destination(filePath);
        }
    }];
    
    //3.启动任务
    [downloadTask resume];
}

+ (BOOL)checkIfNeedDownLoad:(NSString *)downloadURL{
    
    NSString *path = [self getFilePathWith:downloadURL];
    if ([TKFileUtil fileExistAtPath:path]) {
        return NO;
    }
    return YES;
}

+ (NSString *)getFilePathWith:(NSString *)fileName{
    NSString *path = [TKFileUtil pathForDir:[TKFileUtil cachePath] pathComponent:@"fileDown"];
    
    if (![TKFileUtil fileExistAtPath:path]) {
        [TKFileUtil createDirectoryAtPath:path];
    }
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    
    return fullPath;
}


@end
