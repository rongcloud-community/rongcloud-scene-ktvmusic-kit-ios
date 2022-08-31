//
//  RCSKTVCornerContainerView.h
//  Pods
//
//  Created by xuefeng on 2022/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN;

@interface RCSKTVCornerContainerView : UIView
/**
 * @param corner 圆角方向 ex:UIRectCornerTopRight|UIRectCornerTopLeft
 * @param radios 圆角尺寸
 */
- (instancetype)initWithRectCorner:(UIRectCorner)corner radios:(CGFloat)radios;
@end
NS_ASSUME_NONNULL_END
