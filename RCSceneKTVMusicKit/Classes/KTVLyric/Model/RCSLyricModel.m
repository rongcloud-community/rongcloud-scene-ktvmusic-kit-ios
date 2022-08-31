//
//  RCSLyricModel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/21.
//

#import "RCSLyricModel.h"

@implementation RCSLyricModel

- (RCSLyricModelType)type {
    return RCSLyricModelTypeStatic;
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

@implementation RCSSentenceModel

@end
