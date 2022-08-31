//
//  RCSEnhancedLrcModel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricModel.h"

NS_ASSUME_NONNULL_BEGIN
@class RCSELrcSentenceModel,RCSELrcWordModel;

/// 逐字歌词模型
@interface RCSEnhancedLrcModel : RCSLyricModel

@property (nonatomic, strong) NSArray<RCSELrcSentenceModel *> *sentences;

@end

@interface RCSELrcSentenceModel : RCSSentenceModel

@property (nonatomic, copy) NSArray<RCSELrcWordModel *> *words;

@end

@interface RCSELrcWordModel : NSObject

@property (nonatomic, copy) NSString *word;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

@end

NS_ASSUME_NONNULL_END
