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

#import "KASAnnotationRemover.h"

typedef struct KASAnnontationTag {
    const char *start;
    const char *end;
}KASAnnontationTag;

static KASAnnontationTag blockTag = {
    .start = "/*",.end = "*/"
};
static KASAnnontationTag lineTag = {
    .start = "//",.end = "\n"
};
static KASAnnontationTag strTag = {
    .start = "\"",.end = "\""
};

@interface KASAnnotationRemover ()

@end

@implementation KASAnnotationRemover

- (instancetype)initWithString:(NSString *)string {
    if (self = [super init]) {
        _string = string;
    }
    return self;
}

- (NSString *)removeAnnontation {
    const char *string = [self.string cStringUsingEncoding:NSUTF8StringEncoding];
    size_t count = strlen(string);
    char newStr[count];
    int index = 0;
    KASAnnontationTag *tag = NULL;
    for (int i = 0; i < count; i++) {
        
        if (tag == NULL) {
            
            if (i == count - 1) {
                if (string[i] != ' ') newStr[index++] = string[i];
                continue;
            }
            
            char target[3] = {string[i],string[i+1],'\0'};
            if (strcmp(target, blockTag.start) == 0) {
                tag = &blockTag;
                i++;
            }else if (strcmp(target, lineTag.start) == 0) {
                tag = &lineTag;
                i++;
            }else if (target[0] == strTag.start[0]) {
                tag = &strTag;
                if (string[i] != ' ') newStr[index++] = string[i];
            }else {
                if (string[i] != ' ') newStr[index++] = string[i];
            }
            
        }else if (tag == &blockTag) {
            
            if (i == count - 1) {
                continue;
            }
            
            char target[3] = {string[i],string[i+1],'\0'};
            if (strcmp(target, tag->end) == 0) {
                tag = NULL;
                i++;
            }
            
        }else if (tag == &lineTag) {
            
            if (string[i] == lineTag.end[0] || i == count - 1) {
                tag = NULL;
            }
            if (string[i] == lineTag.end[0]) {
                newStr[index++] = string[i];
            }
            
        }else if (tag == &strTag) {
            
            if (string[i] == strTag.end[0] || i == count - 1) {
                tag = NULL;
            }
            newStr[index++] = string[i];
            
        }
        
    }
    
    if (tag) {
        self.error = [NSError errorWithDomain:NSInternalInconsistencyException
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey:@"annontion error,there is no end tag for annontion"}];
        return nil;
    }
    
    newStr[index] = '\0';
    return [[NSString alloc] initWithCString:newStr encoding:NSUTF8StringEncoding];
    
}

@end
