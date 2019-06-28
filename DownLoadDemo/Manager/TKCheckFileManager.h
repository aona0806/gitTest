//
//  TKCheckFileManager.h
//  SimpleOrder
//
//  Created by 奥那 on 2018/8/15.
//  Copyright © 2018年 Persagy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 查看本地文件
 */

@interface TKCheckFileManager : NSObject
/**
 *  account manager 单例
 *
 *  @return manager对象
 */
+(instancetype)sharedInstance;

- (void)cheeckFileWith:(NSString *)fileName controller:(UIViewController *)controller;
@end
