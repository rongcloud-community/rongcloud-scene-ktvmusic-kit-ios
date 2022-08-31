//
//  RCSKTVTunerConfig.h
//  AFNetworking
//
//  Created by 彭蕾 on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVTunerConfig : NSObject

@property (nonatomic, assign) NSInteger reverbSelectedIndex; /// 当前选中第几个，默认为0
@property (nonatomic, assign) float vocalVolume; /// 人声音量大小，默认为70%
@property (nonatomic, assign) float accompVolume; /// 伴奏音量大小，默认为70%
@property (nonatomic, assign) BOOL isEarReturn; /// 耳返是否开启，默认开启
@property (nonatomic, assign) BOOL isLead; /// 是否为主唱，默认为NO

@end

NS_ASSUME_NONNULL_END
