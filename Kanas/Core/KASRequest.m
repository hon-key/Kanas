//
//  KASRequest.m
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import "KASRequest.h"
#import "KASFile.h"

@interface KASRequest ()

@property (nonatomic,copy,readwrite) NSString *alias;
@property (nonatomic,copy,readwrite) NSString *url;
@property (nonatomic,strong,readwrite) NSDictionary<NSString *,NSString *> *headers;
@property (nonatomic,strong,readwrite) NSArray<KASParam *> *requestParams;
@property (nonatomic,strong,readwrite) NSArray<KASParam *> *responseParams;

@end

@implementation KASRequest

@end
