//
//  KASRequest.h
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KASParam.h"

@class KASFile;

NS_ASSUME_NONNULL_BEGIN

@interface KASRequest : NSObject

@property (nonatomic,copy,readonly) NSString *alias;

@property (nonatomic,copy,readonly) NSString *url;

@property (nonatomic,strong,readonly,nullable) NSDictionary<NSString *,NSString *> *headers;

@property (nonatomic,strong,readonly,nullable) NSArray<KASParam *> *requestParams;

@property (nonatomic,strong,readonly,nullable) NSArray<KASParam *> *responseParams;

- (KASRequest *)requestByAddingDefaultParamFromKASFile:(KASFile *)kasFile;

@end

NS_ASSUME_NONNULL_END
