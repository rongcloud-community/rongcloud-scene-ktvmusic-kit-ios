//
//  RCSKTVRoomModel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/13.
//

#import "RCSKTVRoomModel.h"

@implementation RCSKTVRoomModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"songQueue" : [RCSKTVMusicSelectedModel class]};
}

@end

@implementation RCSKTVRoomMusicModel

@end

@implementation RCSKTVMusicSelectedModel

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

