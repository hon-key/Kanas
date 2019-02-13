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
- (instancetype)initWithContentsFile:(NSString *)filePathString asIndex:(BOOL)asIndex;

@property (nonatomic,copy,readonly) NSString *filePath;

@property (nonatomic,copy,readonly) NSString *name;

@property (nonatomic,strong,readonly) NSSet<NSString *> *aliases;

@property (nonatomic,strong,readonly,nullable) NSDictionary<NSString *,NSString *> *keyValues;

@property (nonatomic,strong,readonly,nullable) NSDictionary<NSString *,NSString *> *defaultHeaders;

@property (nonatomic,strong,readonly,nullable) NSArray<KASParam *> *defaultRequestParams;

@property (nonatomic,strong,readonly,nullable) NSArray<KASParam *> *defaultResponseParams;

@property (nonatomic,strong,readonly,nullable) NSDictionary <NSString *,KASRequest *> *requests;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
