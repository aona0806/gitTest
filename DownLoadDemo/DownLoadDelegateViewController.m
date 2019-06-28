//
//  DownLoadDelegateViewController.m
//  DownLoadDemo
//
//  Created by 奥那 on 2018/8/16.
//  Copyright © 2018年 奥那. All rights reserved.
//

#import "DownLoadDelegateViewController.h"

@interface DownLoadDelegateViewController ()<NSURLSessionDelegate>
@property (nonatomic, strong) UIProgressView *progerssView;
/** 下载任务*/
@property (nonatomic ,strong)  NSURLSessionDownloadTask *downloadTask;
/** 恢复下载的数据*/
@property (nonatomic ,strong) NSData *resumeData;
/** 会话对象*/
@property (nonatomic ,strong) NSURLSession *session;

@end

@implementation DownLoadDelegateViewController

-(NSURLSession *)session
{
    if (_session == nil) {
        //让控制器成为NSURLSession的代理，代理方法在主队列，也就是主线程中执行
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)downLoadAction:(id)sender {
//    [self downLoadWithBlock];
    [self downloadFileDataWithDelegate];
}
- (IBAction)pauseAction:(id)sender {
    //暂停任务
    [self.downloadTask suspend];
    NSLog(@"暂停任务----------");
}
- (IBAction)continueAction:(id)sender {
    //先判断用户当前是处于暂停状态还是处于取消
    //用resumeData记录之前下载文件的最后一个结点，创建一个新的下载任务，从这个结点继续下载，并用downloadTask保存这个下载任务
    
    //session是NSURLSessionDownloadTask类型的对象  downloadTaskWithResumeData是返回值为NSURLSessionDownloadTask类型的方法，所以可以用对象调用这个方法

    if (self.resumeData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    }
    
    //继续下载
    [self.downloadTask resume];
    NSLog(@"继续下载++++++++++++");
}
- (IBAction)cancelAction:(id)sender {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
    NSLog(@"取消任务_______________");
}

-(void)downloadFileDataWithDelegate
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"http://192.168.100.65:8080/image-service/common/file_get?systemId=dataPlatform&key=153241277188758130611944943671response12312312.xlsx"];
    
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //在懒加载的方法中创建session
    //3.创建session
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //创建下载任务对象 downloadTask. 通过调用downloadTask对象的resume、suspend、cancel方法，可以实现下载任务的开始，暂停和取消
    //让downloadTask在当前类中的所有方法都可以使用，并且所有方法拿到的downloadTask都是实时的状态，而不是初始的状态
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    
    //5.执行task
    [_downloadTask resume];
    

}

- (void)downLoadWithBlock{
    NSString *path= @"http://192.168.100.65:8080/image-service/common/file_get?systemId=dataPlatform&key=153241277188758130611944943671response12312312.xlsx";
    NSURL *url = [NSURL URLWithString:path];
    
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.创建session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.创建task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 当下载结束(成功|失败)的时候调用
     location:位置,该文件保存到沙盒中的位置
     response:响应头信息
     error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",location);
        
        //6.处理文件
        //6.1 获得文件的名称
        NSString *fileName = response.suggestedFilename;
        
        //6.2 写路径到磁盘+拼接文件的全路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
        
        //6.3 执行剪切操作
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
        
        NSLog(@"%@",fullPath);
        
    }];
    
    //5.执行task
    [downloadTask resume];
    
}

#pragma mark --------------------
#pragma mark NSURLSessionDownloadDelegate
/**
 *  1.写数据的时候调用
 *  @param bytesWritten              本次下载数据的大小
 *  @param totalBytesWritten         当前已经下载数据的总大小
 *  @param totalBytesExpectedToWrite 文件的总大小
 */
//didWriteData

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"当前下载进度:%f",progress);
}
/**
 *  恢复下载的时候调用
 *
 *  @param fileOffset         当前从什么位置开始下载
 *  @param expectedTotalBytes 文件的总大小
 */
//didResumeAtOffset

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"恢复下载---didResumeAtOffset");
}

/**
 * 当下载完成调用
 *
 *  @param location     文件的临时存储路径(磁盘/tmp)
 */
//didFinishDownloadingToURL
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@",location);
    
    //1 获得文件的名称(要下载的文件的文件名称)
    //suggestedFilename是系统推荐的名字,就是URL后面的minion_01.mp4
    NSString *fileName = downloadTask.response.suggestedFilename;
    
    //2 拼接文件的全路径 这个方法获取到的路径是Caches文件夹所在的路径。然后把下载的fileName文件放在Caches文件夹下.如果你想自定义文件的名字，可以把步骤1注释，把2的fileName替换为@"haha.mp4"
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    
    //3 执行剪切操作  把location路径中的文件 剪切到 fullPath路径中
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    
    NSLog(@"%@",fullPath);
}

/**
 *  当整个请求结束的时候调用
 *
 *  @param error   错误信息
 */
//didCompleteWithError
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
}

@end
