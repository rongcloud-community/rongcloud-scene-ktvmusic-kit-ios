//
//  RCSKTVMusicListPresenter.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import <Foundation/Foundation.h>
#import "RCSKTVSongProtocol.h"
#import "RCSKTVMusicProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicListPresenter : NSObject

@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, copy, readonly) NSArray<id<RCSKTVSongProtocol> > *dataModels;
@property (nonatomic, assign, readonly) BOOL noMoreData;

- (void)fetchMusicList:(NSString *)key
            isRefresh:(BOOL)isRefresh
      completionBlock:(void(^)(BOOL success))completionBlock;

- (void)fetchAndDownloadSongWithMusicId:(NSString *)musicId
                               progress:(void(^)(NSProgress * _Nullable progress))progress
                        completionBlock:(void(^)(id<RCSKTVMusicProtocol> _Nullable model))completionBlock;

@end

NS_ASSUME_NONNULL_END
