//
//  RCSKTVDownloadManager.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RCSKTVLoadCompletion)(NSString * _Nullable localPath);
typedef void(^RCSKTVLoadProgress)(NSProgress * _Nullable progress);

@interface RCSKTVDownloadManager : NSObject

+ (instancetype)shared;

/// 远程资源文件是否存在本地缓存
- (nullable NSString *)localPathExistWithURL:(NSString *)url;

- (void)startDownloadWithUrl:(NSString *)url
                    progress:(_Nullable RCSKTVLoadProgress)loadProgress
                  completion:(RCSKTVLoadCompletion)completion;

@end

NS_ASSUME_NONNULL_END
