//  KanasTests.h
//  Copyright (c) 2018 HJ-Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "KASTestCase.h"
#import <Kanas/KASAnnotationRemover.h>
#import <Kanas/KASInterpreter.h>

@interface KanasTests : KASTestCase

@end


@implementation KanasTests

- (void)setUp {
    
}

#pragma mark -
- (void)testExample {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"req" ofType:@"kas"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    KASAnnotationRemover *anontationRemover = [[KASAnnotationRemover alloc] initWithString:string];
    NSString *newStr = [anontationRemover removeAnnontation];
    
    __block NSString *currentSymbol = nil;
    [KASInterpreter.defaultInterpreter syncInterpretWithContentString:newStr options:0 interpretBlock:^(KASInterpreterLinkList * _Nonnull linkList, KASInterpreterKeyValue *const  _Nullable keyValue) {
        if (![currentSymbol isEqualToString:linkList->symbol]) {
            currentSymbol = linkList->symbol;
            NSLog(@"%@",linkList->symbol);
        }
        if (keyValue) {
            NSLog(@"    %@ : %@ : %@",keyValue->key,keyValue->value,keyValue->keyType);
        }
    }];
    

    NSLog(@"%@",path);
}


@end
