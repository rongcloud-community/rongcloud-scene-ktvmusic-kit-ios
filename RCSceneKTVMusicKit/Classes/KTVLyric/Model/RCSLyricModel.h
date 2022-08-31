//
//  RCSLyricModel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 歌词类型
typedef NS_ENUM(NSUInteger, RCSLyricModelType) {
    RCSLyricModelTypeStatic = 0, /// 静态
    RCSLyricModelTypeSimpleLrc, /// 逐句
    RCSLyricModelTypeEnhancedLrc, /// 逐字
};

/// 歌词模型
@interface RCSLyricModel : NSObject

@property (nonatomic, assign) RCSLyricModelType type;
@property (nonatomic, copy) NSArray<NSString *> *lines;

@end

@interface RCSSentenceModel : NSObject

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
