//
//  RCSEnhancedLrcModel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSEnhancedLrcModel.h"

@implementation RCSEnhancedLrcModel

- (RCSLyricModelType)type {
    return RCSLyricModelTypeEnhancedLrc;
}


@end

@implementation RCSELrcSentenceModel

- (NSString *)description {
    return [self yy_modelDescription];
}


@end

@implementation RCSELrcWordModel

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
