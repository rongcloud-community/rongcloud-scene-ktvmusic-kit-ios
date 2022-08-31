//
//  RCSKTVMusicGroupCategoryModel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/11.
//

#import "RCSKTVMusicGroupCategoryModel.h"

@implementation RCSKTVChannelSheetModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"record" : [RCSKTVMusicGroupCategoryModel class]};
}

@end

@implementation RCSKTVMusicGroupCategoryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"categoryId" :  @"sheetId",
        @"name" :  @"sheetName"
    };
}

@end
