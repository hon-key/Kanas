//
//  KASFile.m
//  Kanas
//
//  Created by Ruite Chen on 2019/2/12.
//  Copyright © 2019 CAI. All rights reserved.
//

#import "KASFile.h"
#import "KASInterpreter.h"
#import "KASAnnotationRemover.h"

@implementation KASFile
- (instancetype)initWithContentsFile:(NSString *)filePathString asIndex:(BOOL)asIndex {
    if (self = [super init]) {
        
        NSError *error = nil;
        NSString *fileString = [[NSString alloc] initWithContentsOfFile:filePathString encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@",error);
            return nil;
        }
        
        KASAnnotationRemover *annotationRemover = [[KASAnnotationRemover alloc] initWithString:fileString];
        [annotationRemover removeAnnontation];
        if (annotationRemover.error) {
            NSLog(annotationRemover.error);
            return nil;
        }
        fileString = annotationRemover.string;
        
        KASInterpreterInterpretOptions options = asIndex ? KASInterpreterInterpretOptionsIndex : KASInterpreterInterpretOptionsDefault;
        [KASInterpreter.defaultInterpreter syncInterpretWithContentString:fileString options:options interpretBlock:^(KASInterpreterLinkList * _Nonnull linkList, KASInterpreterKeyValue *const  _Nullable keyValue) {
            
            
            
        }];
        
    }
    return self;
}
@end
