//
//  KASInterpreter.h
//  Kanas
//
//  Created by Ruite Chen on 2018/12/14.
//  Copyright © 2018 CAI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * KASkeyType;
FOUNDATION_EXPORT KASkeyType const KASString;
FOUNDATION_EXPORT KASkeyType const KASNumber;
FOUNDATION_EXPORT KASkeyType const KASDict;
FOUNDATION_EXPORT KASkeyType const KASBool;
FOUNDATION_EXPORT KASkeyType const KASEnum;
FOUNDATION_EXPORT KASkeyType const KASStringArr;
FOUNDATION_EXPORT KASkeyType const KASNumberArr;
FOUNDATION_EXPORT KASkeyType const KASDictArr;
FOUNDATION_EXPORT KASkeyType const KASBoolArr;
FOUNDATION_EXPORT KASkeyType const KASEnumArr;

typedef NSString * KASSymbol;
FOUNDATION_EXPORT KASSymbol const KASSymbolKanas;
FOUNDATION_EXPORT KASSymbol const KASSymbolInterface;
FOUNDATION_EXPORT KASSymbol const KASSymbolKeyValue;
FOUNDATION_EXPORT KASSymbol const KASSymbolHeader;
FOUNDATION_EXPORT KASSymbol const KASSymbolRequest;
FOUNDATION_EXPORT KASSymbol const KASSymbolResponse;

typedef NS_ENUM(NSInteger, KASInterpreterInterpretOptions) {
    KASInterpreterInterpretOptionsDefault = 0,
    KASInterpreterInterpretOptionsIndex = 1
};

typedef struct KASInterpreterLinkList {
    NSString *symbol;
    struct KASInterpreterLinkList *next;
    struct KASInterpreterLinkList *pre;
}KASInterpreterLinkList;

typedef struct KASInterpreterKeyValue {
    NSString *key;
    id value;
    KASkeyType keyType;
    NSString *symbol;
}KASInterpreterKeyValue;


@interface KASInterpreter : NSObject

+ (instancetype)defaultInterpreter;

- (void)syncInterpretWithContentString:(NSString *)string
                               options:(KASInterpreterInterpretOptions)options
                        interpretBlock:(void(^)(KASInterpreterLinkList *linkList, KASInterpreterKeyValue * const _Nullable keyValue))block;

- (void)syncInterpretWithContentString:(NSString *)string
                           requestName:(nullable NSString *)requestName
                               options:(KASInterpreterInterpretOptions)options
                        interpretBlock:(void(^)(KASInterpreterLinkList *linkList,  KASInterpreterKeyValue * const _Nullable keyValue))block;

@end


NS_ASSUME_NONNULL_END

