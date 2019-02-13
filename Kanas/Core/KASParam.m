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

@interface KASParam ()

@end

@implementation KASParam
- (instancetype)initWithAlias:(NSString *)alias type:(KASParamType)type key:(NSString *)key additional:(id)additional {
    if (self = [super init]) {
        _alias = alias;
        _type = type;
        _key = key;
        _additional = additional;
    }
    return self;
}

@end


