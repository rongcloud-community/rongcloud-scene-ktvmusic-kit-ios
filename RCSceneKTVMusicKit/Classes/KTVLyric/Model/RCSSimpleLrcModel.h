//
//  RCSSimpleLrcModel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricModel.h"

NS_ASSUME_NONNULL_BEGIN
@class RCSSLrcSentenceModel;
@interface RCSSimpleLrcModel : RCSLyricModel

@property (nonatomic, strong) NSArray<RCSSentenceModel *> *sentences;

@end

NS_ASSUME_NONNULL_END
