//
//  TKCheckFileManager.m
//  SimpleOrder
//
//  Created by 奥那 on 2018/8/15.
//  Copyright © 2018年 Persagy. All rights reserved.
//

#import "TKCheckFileManager.h"
#import "TKDownLoadManager.h"

@interface TKCheckFileManager()<UIDocumentInteractionControllerDelegate>

@property (nonatomic , strong)UIViewController *viewController;

@property (nonatomic , strong)UIDocumentInteractionController *documentVC;

@end

@implementation TKCheckFileManager
+(instancetype)sharedInstance{
    static TKCheckFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKCheckFileManager alloc]init];
    });
    return manager;
}

- (void)cheeckFileWith:(NSString *)fileName controller:(UIViewController *)controller{
    _viewController = controller;
    NSString *filePath = [TKDownLoadManager getFilePathWith:fileName];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if (url) {
        self.documentVC = [UIDocumentInteractionController interactionControllerWithURL:url];
        //设置代理 --本应用内预览必须要添加代理UIDocumentInteractionControllerDelegate
        self.documentVC.delegate = self;

        NSArray *array = [fileName componentsSeparatedByString:@"."];
        if ([self canImmediateOpen:array.lastObject]) {
            [_documentVC presentPreviewAnimated:YES];
        }else{
            BOOL canOpen =  [self.documentVC presentOpenInMenuFromRect:CGRectZero inView:_viewController.view animated:YES];

            if (canOpen == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到可以打开该文件的应用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

    }
}

- (BOOL)canImmediateOpen:(NSString *)type{
    //项目中只支持一下格式的预览
    if ([type containsString:@"pdf"] || [type containsString:@"doc"] || [type containsString:@"ppt"] ||[type containsString:@"xls"] ) {
        return YES;
    }
    return NO;
}

#pragma mark - UIDocumentInteractionControllerDelegate
-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return _viewController;
}

-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return _viewController.view;
}

-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return _viewController.view.bounds;
}
@end
