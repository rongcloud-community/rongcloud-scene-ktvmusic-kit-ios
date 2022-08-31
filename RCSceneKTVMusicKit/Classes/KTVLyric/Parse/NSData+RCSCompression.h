//
//  NSData+RCSCompression.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// data压缩/解压缩，zlib & gzip
@interface NSData (RCSCompression)

// ZLIB
- (NSData *)zlibInflate;
- (NSData *)zlibDeflate;

// GZIP
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;

@end

NS_ASSUME_NONNULL_END
