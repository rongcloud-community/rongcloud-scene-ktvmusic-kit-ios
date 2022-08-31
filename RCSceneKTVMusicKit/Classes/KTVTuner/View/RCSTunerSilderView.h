//
//  RCSTunerVolumeView.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSTunerSilderView : UIView

@property(nonatomic, assign) float value;

@property(nonatomic, copy) void(^valueChangedBlock)(float value);

- (instancetype)initWithTitle:(NSString *)title thumbSize:(CGSize)size;


@end

@interface RCSTunerSlider : UISlider

@property (nonatomic, assign) CGSize thumbSize;

@end

NS_ASSUME_NONNULL_END
