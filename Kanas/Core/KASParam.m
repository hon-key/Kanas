//
//  KASParam.m
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import "KASParam.h"
#import <objc/runtime.h>

@interface KASParam ()

@end

@implementation KASParam
- (instancetype)initWithAlias:(NSString *)alias type:(KASkeyType)type key:(NSString *)key additional:(id)additional {
    if (self = [super init]) {
        _alias = alias;
        _type = type;
        _key = key;
        _additional = additional;
    }
    return self;
}

@end


