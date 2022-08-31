//
//  RCSKTVTunerConfig.m
//  AFNetworking
//
//  Created by 彭蕾 on 2022/6/30.
//

#import "RCSKTVTunerConfig.h"

@implementation RCSKTVTunerConfig

- (instancetype)init {
    if (self = [super init]) {
        self.reverbSelectedIndex = 0;
        self.vocalVolume = 0.7;
        self.accompVolume = 0.7;
        self.isEarReturn = YES;
        self.isLead = NO;
    }
    return self;
}

@end
