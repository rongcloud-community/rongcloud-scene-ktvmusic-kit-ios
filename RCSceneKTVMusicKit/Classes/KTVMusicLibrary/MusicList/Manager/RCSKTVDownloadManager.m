//
//  RCSKTVDownloadManager.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/11.
//

#import "RCSKTVDownloadManager.h"
#import <RCSceneNetworkKit/RCSNetworkKit.h>
#import "RCSNetworkDataHandler.h"

@interface RCSKTVDownloadManager ()

@property (nonatomic, strong) RCSNetworkDataHandler *dataHandler;
/// 文件缓存路径，默认为caches/ktvmusic
@property (nonatomic, strong) NSString *downloadFolder;

@end

@implementation RCSKTVDownloadManager
+ (instancetype)shared {
    static RCSKTVDownloadManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        _sharedManager.dataHandler = [RCSNetworkDataHandler new];
        _sharedManager.downloadFolder = [self downloadFolder];
    });

    return _sharedManager;
}

- (nullable NSString *)localPathExistWithURL:(NSString *)url {
    if (url.length == 0) {
        return nil;
    }
    
    NSString *fileName = [[NSURL URLWithString:url] lastPathComponent];
    NSString *downloadTargetPath = [NSString pathWithComponents:@[self.downloadFolder, fileName]];
    
    /// 缓存不存在则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        return nil;
    }
    return downloadTargetPath;
}

- (void)startDownloadWithUrl:(NSString *)url
                    progress:(RCSKTVLoadProgress)loadProgress
                  completion:(RCSKTVLoadCompletion)completion {
    if (url.length == 0) {
        !completion ?: completion(nil);
        return ;
    }
    
    NSString *fileName = [[NSURL URLWithString:url] lastPathComponent];
    NSString *downloadTargetPath = [NSString pathWithComponents:@[self.downloadFolder, fileName]];
    
    /// 缓存存在则不用重新下载
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        !completion ?: completion(downloadTargetPath);
        return ;
    }
    
    RCSNetworkConfig *config = [RCSNetworkConfig new];
    config.url = url;
    [self.dataHandler requestWithUrlConfig:config
                              downloadPath:downloadTargetPath
                          downloadProgress:^(NSProgress * _Nonnull progress) {
        !loadProgress ?: loadProgress(progress);
    } completion:^(RCSResponseModel * _Nonnull model) {
        NSURL *url = model.data;
        !completion ?: completion(url.path);
    }];
}

+ (NSString *)downloadFolder {
    NSString *cachePath = [self cachesDirectoryPath];
    NSString *path = [cachePath stringByAppendingPathComponent:@"ktvmusic"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)cachesDirectoryPath {
    static NSString *cacheDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    });
    return cacheDirectory;
}




@end
