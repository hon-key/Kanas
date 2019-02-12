//
//  KASParam.h
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * KASParamType;
FOUNDATION_EXPORT KASParamType const KASString;
FOUNDATION_EXPORT KASParamType const KASNumber;
FOUNDATION_EXPORT KASParamType const KASDict;
FOUNDATION_EXPORT KASParamType const KASBool;
FOUNDATION_EXPORT KASParamType const KASEnum;
FOUNDATION_EXPORT KASParamType const KASStringArr;
FOUNDATION_EXPORT KASParamType const KASNumberArr;
FOUNDATION_EXPORT KASParamType const KASDictArr;
FOUNDATION_EXPORT KASParamType const KASBoolArr;
FOUNDATION_EXPORT KASParamType const KASEnumArr;

@interface KASParam : NSObject

@property (nonatomic,copy,readonly) NSString *alias;

@property (nonatomic,copy,readonly) KASParamType type;

@property (nonatomic,copy,readonly) NSString *key;

@property (nonatomic,strong,readonly,nullable) id additional;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAlias:(NSString *)alias type:(KASParamType)type key:(NSString *)key additional:(nullable id)additional;


@end

NS_ASSUME_NONNULL_END
