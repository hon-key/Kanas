//
//  KASParam.m
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import "KASParam.h"
#import <objc/runtime.h>

KASParamType const KASString = @"com.kanas.string";
KASParamType const KASNumber = @"com.kanas.number";
KASParamType const KASDict = @"com.kanas.dict";
KASParamType const KASBool = @"com.kanas.bool";
KASParamType const KASEnum = @"com.kanas.enum";
KASParamType const KASStringArr = @"com.kanas.[string]";
KASParamType const KASNumberArr = @"com.kanas.[number]";
KASParamType const KASDictArr = @"com.kanas.[dict]";
KASParamType const KASBoolArr = @"com.kanas.[bool]";
KASParamType const KASEnumArr = @"com.kanas.[enum]";

@interface KASParamCache ()

@property (nonatomic,strong) NSMutableDictionary<NSString *,KASParam *> *pool;
@property (nonatomic,strong) dispatch_queue_t synchronizationQueue;
@property (nonatomic,assign) UInt64 currentMemoryUsage;

@end

@interface KASParam ()

@property (nonatomic,copy) NSString *storedCacheKey;

@end

@implementation KASParam
- (instancetype)initWithAlias:(NSString *)alias type:(KASParamType)type key:(NSString *)key additional:(id)additional {
    if (self = [super init]) {
        _alias = alias;
        _type = type;
        _key = key;
        _additional = additional;
        _storedCacheKey = [KASParam cacheKeyWithAlias:alias type:type key:key additional:additional];
    }
    return self;
}
+ (instancetype)paramWithAlias:(NSString *)alias type:(KASParamType)type key:(NSString *)key additional:(id)additional {
    KASParam *param = [[KASParamCache cache] paramWithKey:[self cacheKeyWithAlias:alias type:type key:key additional:additional]];
    if (param == nil) {
        param = [[KASParam alloc] initWithAlias:alias type:type key:key additional:additional];
        [[KASParamCache cache] cacheParam:param];
    }
    return param;
}

- (NSString *)cacheKey {
    return self.cacheKey;
}

+ (NSString *)cacheKeyWithAlias:(NSString *)alias type:(KASParamType)type key:(NSString *)key additional:(id)additional {
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@%@%@",alias,type,key];
    if (additional != nil) {
        if (type == KASDict || type == KASDictArr) {
            NSArray<KASParam *> *params = additional;
            for (KASParam *param in params) {
                [string appendFormat:@"%@",param.cacheKey];
            }
        }else if (type == KASEnum || type == KASEnumArr) {
            NSDictionary<NSString *,NSNumber *> *enumTypes = additional;
            NSArray *keys = [enumTypes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
                return [obj1 compare:obj2 options:NSLiteralSearch];
            }];
            for (NSString *key in keys) {
                [string appendFormat:@"%@%@",key,enumTypes[key]];
            }
        }
    }
    return [NSString stringWithString:string];
}

+ (UInt64)totalBytes {
    return class_getInstanceSize(self);
}

@end

@implementation KASParamCache

+ (instancetype)cache {
    static KASParamCache *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[KASParamCache alloc] init];
        singleton.pool = [[NSMutableDictionary alloc] init];
        singleton.memoryCapacity = 7 * 1024 * 1024;
        singleton.memoryCapacity = 3 * 1024 * 1024;
        singleton.synchronizationQueue = dispatch_queue_create("com.Kanas.KASParamCache.synchronizationQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return singleton;
}

- (void)cacheParam:(KASParam *)param {
    dispatch_barrier_async(self.synchronizationQueue, ^{
        NSString *targetCacheKey = param.cacheKey;
        KASParam *previousParam = self.pool[targetCacheKey];
        if (previousParam == nil) {
            self.currentMemoryUsage += KASParam.totalBytes;
        }
        self.pool[targetCacheKey] = param;
    });
    dispatch_barrier_async(self.synchronizationQueue, ^{
        //TODO : 如果需要，就去减少内存
    });
}

- (KASParam *)paramWithKey:(NSString *)key {
    __block KASParam *param = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        param = self.pool[key];
    });
    return param;
}

@end


