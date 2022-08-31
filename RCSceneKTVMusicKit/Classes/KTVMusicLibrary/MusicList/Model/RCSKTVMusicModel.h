//
//  RCSKTVMusicModel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import <Foundation/Foundation.h>
#import "RCSKTVMusicProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class RCSKTVMusicSubVersionModel;
@interface RCSKTVMusicModel : NSObject<RCSKTVMusicProtocol>

@property(nonatomic, copy) NSString *musicId;
@property(nonatomic, copy) NSString *fileUrl;
@property(nonatomic, copy) NSString *dynamicLyricUrl;
@property(nonatomic, copy) NSString *staticLyricUrl;

@property(nonatomic, copy) NSString *kugouLyricUrl;
@property(nonatomic, strong) NSArray<RCSKTVMusicSubVersionModel *> *subVersions;

@end

@interface RCSKTVMusicSubVersionModel : NSObject

@property(nonatomic, copy) NSString *versionName;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *wavePath;
@property(nonatomic, assign) int startTime;
@property(nonatomic, assign) int endTime;

@end

NS_ASSUME_NONNULL_END
