//
//  TKDownLoadManager.h
//  DownLoadDemo
//
//  Created by 奥那 on 2018/8/13.
//  Copyright © 2018年 奥那. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 下载文件
 */

@interface TKDownLoadManager : NSObject

/**
 *  account manager 单例
 *
 *  @return manager对象
 */
+(instancetype)sharedInstance;


/**
 检查是否已下载

 @param downloadURL 下载url
 @return <#return value description#>
 */
+ (BOOL)checkIfNeedDownLoad:(NSString *)downloadURL;


/**
 获取本地缓存路径

 @param fileName 文件名
 @return <#return value description#>
 */
+ (NSString *)getFilePathWith:(NSString *)fileName;


/**
 下载

 @param downloadURL <#downloadURL description#>
 @param progress <#progress description#>
 @param destination <#destination description#>
 @param faliure <#faliure description#>
 */
+(void)downloadURL:(NSString *) downloadURL progress:(void (^)(NSProgress *downloadProgress))progress destination:(void (^)(NSURL *targetPath))destination failure:(void(^)(NSError *error))faliure;
@end
