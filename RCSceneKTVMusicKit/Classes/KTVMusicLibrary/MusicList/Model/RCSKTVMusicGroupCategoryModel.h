//
//  RCSKTVMusicGroupCategoryModel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/11.
//

#import <Foundation/Foundation.h>
#import "RCSKTVMusicGroupCategoryProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class RCSKTVMusicGroupCategoryModel;
@interface RCSKTVChannelSheetModel: NSObject

@property(nonatomic, strong) NSArray<RCSKTVMusicGroupCategoryModel *> *record;

@end

@interface RCSKTVMusicGroupCategoryModel: NSObject <RCSKTVMusicGroupCategoryProtocol>

@property(nonatomic, copy) NSString *categoryId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
