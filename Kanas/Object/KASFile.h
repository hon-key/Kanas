//
//  KASFile.h
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KASRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KASFile : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContentsFile:(NSString *)filePathString;

@property (nonatomic,strong,readonly,nonnull) NSDictionary<NSString *,NSString *> *keyValues;

@property (nonatomic,strong,readonly,nonnull) NSDictionary<NSString *,NSString *> *header;

@end

NS_ASSUME_NONNULL_END
