//
//  ViewController.m
//  DownLoadDemo
//
//  Created by 奥那 on 2018/8/13.
//  Copyright © 2018年 奥那. All rights reserved.
//

#import "ViewController.h"
#import "TKDownLoadManager.h"
#import "WebViewController.h"
#import "DownLoadDelegateViewController.h"
#import <QuickLook/QuickLook.h>
#import "TKCheckFileManager.h"

@interface ViewController ()<UIDocumentInteractionControllerDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (nonatomic, strong) UIButton *downButton;

@property (nonatomic, strong) UIButton *chenckButton;

@property (nonatomic , strong)UIDocumentInteractionController *documentVC;

@property (nonatomic , strong) NSURL *fileUrl;
@end

@implementation ViewController

-(UIButton *)downButton{
    if (!_downButton) {
        _downButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _downButton.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50);
        [_downButton setTitle:@"下载" forState:(UIControlStateNormal)];
        [_downButton addTarget:self
                        action:@selector(downLoadAction:)
              forControlEvents:(UIControlEventTouchUpInside)];
        [_downButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    }
    return _downButton;
}

-(UIButton *)chenckButton{
    if (!_chenckButton) {
        _chenckButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _chenckButton.frame = CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 50);
        [_chenckButton setTitle:@"查看" forState:(UIControlStateNormal)];
        [_chenckButton addTarget:self
                        action:@selector(checkDownLoadFile:)
              forControlEvents:(UIControlEventTouchUpInside)];
        [_chenckButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    }
    return _chenckButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.downButton];
    [self.view addSubview:self.chenckButton];

}

- (void)downLoadAction:(UIButton *)sender{

    //可增加判断，该文件是否已下载，若已下载则可以直接进行处理
//        if (![TKDownLoadManager checkIfNeedDownLoad:@""]) {
//            [[TKCheckFileManager sharedInstance] cheeckFileWith:@"" controller:self];
//            return;
//        }
    
    //下载文件
    //正常需要传入下载地址，demo中传入的是写入本地的名称，地址是写死的一个图片的下载地址
        [TKDownLoadManager downloadURL:@"img1.jpg" progress:^(NSProgress *downloadProgress) {
            
            NSLog(@"%@",downloadProgress);
            
        } destination:^(NSURL *targetPath) {
            
            NSLog(@"%@",targetPath);
            
        } failure:^(NSError *error) {

            NSLog(@"error -- %@",error);
        }];
    
}

- (void)checkDownLoadFile:(UIButton *)sender{
    
    //预览
    //预览封装  只需要传入需要预览的文件名就可以
//    [[TKCheckFileManager sharedInstance] cheeckFileWith:@"img1.jpg" controller:self];
    
    //使用QLPreviewController进行预览，效果与UIDocumentInteractionControllerDelegate类似
    
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    self.fileUrl = url;
//    if ([QLPreviewController canPreviewItem:(id<QLPreviewItem>)url]) {
//        QLPreviewController *qlVc = [[QLPreviewController alloc] init];
//        qlVc.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
//        qlVc.delegate = self;
//        qlVc.dataSource = self;
//        qlVc.navigationController.navigationBar.userInteractionEnabled = YES;
//        qlVc.view.userInteractionEnabled = YES;
//        [self presentViewController:qlVc animated:YES completion:nil];
//    }
    
//    WebViewController *web = [[WebViewController alloc] init];
//    [self.navigationController pushViewController:web animated:YES];
    
    NSURL * url = [NSURL URLWithString:@"simpleOrder://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen){
        [[UIApplication sharedApplication] openURL:url];
    }else {
        NSLog(@"失败");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - QLPreviewController 代理方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.fileUrl;
}



@end
