//
//  RCSTunerToneView.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSTunerStepperView : UIView

@property(nonatomic, assign) int value;
- (instancetype)initWithTitle:(NSString *)title;

@property(nonatomic, copy) void(^valueChangedBlock)(int value);

@end

/**
 [ - 10 + ]
 */
@interface RCSStepperView : UIView

@property(nonatomic) int value;                        // default is 0.
@property(nonatomic) int minimumValue;                 // default 0.
@property(nonatomic) int maximumValue;                 // default 100.
@property(nonatomic) int stepValue;                    // default 1. must be greater than 0
@property(nonatomic, copy) void(^valueChangedBlock)(int value);

@end

NS_ASSUME_NONNULL_END
