//
//  KASFile.h
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KASRequest.h"
#import "KASParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface KASFile : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContentsFile:(NSString *)filePathString;

@property (nonatomic,strong,readonly,nonnull) NSDictionary<NSString *,NSString *> *keyValues;

@property (nonatomic,strong,readonly,nonnull) NSDictionary<NSString *,NSString *> *header;

@property (nonatomic,strong,readonly,nonnull) NSArray<KASParam *> *request;

@property (nonatomic,strong,readonly,nonnull) NSArray<KASParam *> *response;

@end

NS_ASSUME_NONNULL_END
