//
//  RCSReverbItem.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/7.
//

#import <Foundation/Foundation.h>
#import <RCSceneKTVMusicKit/RCSKTVMusicKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSReverbItem : NSObject<RCSReverbItemProtocol, NSCopying>

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
