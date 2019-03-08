//
//  KASParam.h
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KASInterpreter.h"

NS_ASSUME_NONNULL_BEGIN

@interface KASParam : NSObject

@property (nonatomic,copy,readonly) NSString *alias;

@property (nonatomic,copy,readonly) KASkeyType type;

@property (nonatomic,copy,readonly) NSString *key;

@property (nonatomic,strong,readonly,nullable) id additional;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAlias:(NSString *)alias type:(KASkeyType)type key:(NSString *)key additional:(nullable id)additional;


@end

NS_ASSUME_NONNULL_END
