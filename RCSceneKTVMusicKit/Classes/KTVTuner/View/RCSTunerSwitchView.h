//
//  RCSTunerSwitchView.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSTunerSwitchView : UIView

@property(nonatomic, copy) void(^valueChangedBlock)(BOOL isOn);
@property(nonatomic, assign) BOOL isOn;

- (instancetype)initWithTitle:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
