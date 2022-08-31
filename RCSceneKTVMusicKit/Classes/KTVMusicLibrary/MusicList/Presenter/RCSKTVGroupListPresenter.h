//
//  RCSKTVGroupListPresenter.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import <Foundation/Foundation.h>
#import "RCSKTVMusicGroupCategoryProtocol.h"
#import "RCSKTVMusicProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVGroupListPresenter : NSObject

@property (nonatomic, copy, readonly) NSArray<id<RCSKTVMusicGroupCategoryProtocol>> *dataModels;

- (void)fetchGroupListWithCompletionBlock:(void(^)(BOOL success))completionBlock;

@end

NS_ASSUME_NONNULL_END
