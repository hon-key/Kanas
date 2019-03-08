//
//  KASInterpreter.m
//  Kanas
//
//  Created by Ruite Chen on 2018/12/14.
//  Copyright © 2018 CAI. All rights reserved.
//

#import "KASInterpreter.h"

KASkeyType const KASString = @"string";
KASkeyType const KASNumber = @"number";
KASkeyType const KASDict = @"dict";
KASkeyType const KASBool = @"bool";
KASkeyType const KASEnum = @"enum{";
KASkeyType const KASStringArr = @"[string]";
KASkeyType const KASNumberArr = @"[number]";
KASkeyType const KASDictArr = @"[dict]{";
KASkeyType const KASBoolArr = @"[bool]";
KASkeyType const KASEnumArr = @"[enum]{";

KASSymbol const KASSymbolKanas = @"-kanas{";
KASSymbol const KASSymbolInterface = @"-interface{";
KASSymbol const KASSymbolKeyValue = @"KASSymbolKeyValue";
KASSymbol const KASSymbolHeader = @"header={";
KASSymbol const KASSymbolRequest = @"request={";
KASSymbol const KASSymbolResponse = @"response={";


static inline KASInterpreterLinkList * kas_interpreter_stack_push(KASInterpreterLinkList *linkList, NSString *str) {
    KASInterpreterLinkList *next = malloc(sizeof(KASInterpreterLinkList));
    memset((void *)next, 0, sizeof(KASInterpreterLinkList));
    next->symbol = str;
    if (linkList != NULL) {
        linkList->next = next;
        next->pre = linkList;
    }
    return next;
}
static inline KASInterpreterLinkList * kas_interpreter_stack_pop(KASInterpreterLinkList *linkList) {
    KASInterpreterLinkList *pre = linkList->pre;
    free(linkList);
    return pre;
}

@interface KASInterpreter ()
@property (nonatomic,strong) NSHashTable<NSString *> *keyTypeTable;
@property (nonatomic,strong) NSPredicate *keyValueMatchingPredicate;
@end


@implementation KASInterpreter

+ (instancetype)defaultInterpreter {
    static KASInterpreter *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[KASInterpreter alloc] init];
        singleton.keyValueMatchingPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([^\"^=]+=)?\"[^\"]+\"(:.+)?$"];
        singleton.keyTypeTable = [NSHashTable weakObjectsHashTable];
        [singleton.keyTypeTable addObject:KASString];
        [singleton.keyTypeTable addObject:KASNumber];
        [singleton.keyTypeTable addObject:KASDict];
        [singleton.keyTypeTable addObject:KASBool];
        [singleton.keyTypeTable addObject:KASEnum];
        [singleton.keyTypeTable addObject:KASStringArr];
        [singleton.keyTypeTable addObject:KASNumberArr];
        [singleton.keyTypeTable addObject:KASDictArr];
        [singleton.keyTypeTable addObject:KASBoolArr];
        [singleton.keyTypeTable addObject:KASEnumArr];
        
    });
    return singleton;
}

- (void)syncInterpretWithContentString:(NSString *)string
                               options:(KASInterpreterInterpretOptions)options
                        interpretBlock:(void (^)(KASInterpreterLinkList * _Nonnull, KASInterpreterKeyValue *const _Nullable))block {

    [self syncInterpretWithContentString:string requestName:nil options:options interpretBlock:block];
    
}

- (void)syncInterpretWithContentString:(NSString *)string
                           requestName:(NSString *)requestName
                               options:(KASInterpreterInterpretOptions)options
                        interpretBlock:(void (^)(KASInterpreterLinkList * _Nonnull, KASInterpreterKeyValue *const _Nullable))block {
    
    __block KASInterpreterLinkList *linkList = NULL;
    __block KASInterpreterKeyValue *data = NULL;
    [string enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
//        NSLog(@"%@",line);
        if (linkList == NULL) {
            if ([line isEqualToString:KASSymbolKanas]) {
                linkList = kas_interpreter_stack_push(linkList, KASSymbolKanas);
            }else if ([line isEqualToString:KASSymbolInterface]) {
                linkList = kas_interpreter_stack_push(linkList, KASSymbolInterface);
            }else if (![line isEqualToString:@""]) {
                NSLog(@"unkown symbol:%@",line);
                if (data) {
                    free(data);
                    data = NULL;
                }
                *stop = YES;
            }
        }else {
            
            if ([line isEqualToString:@"}"]) {
                linkList = kas_interpreter_stack_pop(linkList);
                return;
            }
            
            if ([line isEqualToString:KASSymbolHeader]) {
                linkList = kas_interpreter_stack_push(linkList, KASSymbolHeader);
            }else if ([line isEqualToString:KASSymbolRequest]) {
                linkList = kas_interpreter_stack_push(linkList, KASSymbolRequest);
            }else if ([line isEqualToString:KASSymbolResponse]) {
                linkList = kas_interpreter_stack_push(linkList, KASSymbolResponse);
            }else {
                if ([self.keyValueMatchingPredicate evaluateWithObject:line]) {
                    NSInteger first = [line rangeOfString:@"\""].location;
                    NSInteger second = [line rangeOfString:@"\"" options:0 range:NSMakeRange(first+1, line.length - first - 1)].location;
                    NSString *key = [line substringToIndex:first];
                    NSString *value = [[line substringFromIndex:first + 1] substringToIndex:second - first - 1];
                    NSString *keyType = [line substringFromIndex:second + 1];
                    keyType = ![keyType isEqualToString:@""] ? [keyType substringFromIndex:1] : keyType;
                    if ([keyType isEqualToString:@""]) {
                        keyType = KASString;
                    }else if (![self.keyTypeTable containsObject:keyType]) {
                        NSLog(@"unkown type");
                        *stop = YES;
                        return;
                    }
                    data = malloc(sizeof(KASInterpreterKeyValue));
                    memset((void *)data, 0, sizeof(KASInterpreterKeyValue));
                    data->key = ![key isEqualToString:@""] ? [key substringToIndex:key.length-1] : value;
                    data->value = value;
                    data->keyType = keyType;
                    data->symbol = line;
                }else {
                    NSLog(@"unkown key-value");
                    *stop = YES;
                    return;
                }
            }
            
            
        }
        
        if (linkList) {
            block(linkList,data);
            if (data) {
                if ([data->keyType isEqualToString:KASEnum] ||
                    [data->keyType isEqualToString:KASDict] ||
                    [data->keyType isEqualToString:KASEnumArr] ||
                    [data->keyType isEqualToString:KASDictArr]) {
                    linkList = kas_interpreter_stack_push(linkList, KASSymbolResponse);
                }
                free(data);
                data = NULL;
            }
        }
        
    }];
    
    
}

@end

