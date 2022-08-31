//
//  RCSReverbItem.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/7.
//

#import "RCSReverbItem.h"
#import <YYModel/YYModel.h>

@implementation RCSReverbItem

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self yy_modelCopy];
}

@end
