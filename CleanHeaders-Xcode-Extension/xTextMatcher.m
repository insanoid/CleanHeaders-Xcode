//
//  xTextMatcher.m
//  xTextHandler
//
//  Created by cyan on 16/6/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "xTextMatcher.h"
#import <AppKit/AppKit.h>

static const NSInteger xTextInvalidLine = -1;

typedef void (^xTextSelectionLineBlock) (NSInteger index, NSString *line, NSString *clipped);

@implementation xTextMatchResult

+ (instancetype)clipboardResult {
    xTextMatchResult *result = [[xTextMatchResult alloc] init];
    result.text = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
    result.range = NSMakeRange(0, result.text.length);
    result.clipboard = YES;
    return result;
}

+ (instancetype)resultWithText:(NSString *)text clipped:(NSString *)clipped {
    xTextMatchResult *result = [[xTextMatchResult alloc] init];
    result.text = text;
    result.range = [text rangeOfString:clipped];
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@", self.text, NSStringFromRange(self.range)];
}

@end

@implementation xTextMatcher


/**
 Enumerate lines in XCSourceEditorCommandInvocation

 @param invocation XCSourceEditorCommandInvocation
 @param selection  XCSourceTextRange
 @param block      (index, line, clipped)
 */
+ (void)enumerate:(XCSourceEditorCommandInvocation *)invocation selection:(XCSourceTextRange *)selection lineBlock:(xTextSelectionLineBlock)block {
    
    NSInteger startLine = selection.start.line;
    NSInteger startColumn = selection.start.column;
    NSInteger endLine = selection.end.line;
    NSInteger endColumn = selection.end.column;
    
    // handle clipboard if selected nothing
    if (startLine == endLine && startColumn == endColumn) {
        block(xTextInvalidLine, @"", @"");
        return;
    }
    
    for (NSInteger index=startLine; index<=endLine; ++index) {
        
        NSString *line = invocation.buffer.lines[index];
        NSString *clipped;
        
        if (startLine == endLine) { // single line
            clipped = [line substringWithRange:NSMakeRange(startColumn, endColumn-startColumn+1)];
        } else if (index == startLine) { // first line
            clipped = [line substringFromIndex:startColumn];
        } else if (index == endLine) { // last line
            clipped = [line substringToIndex:endColumn+1];
        } else { // common line
            clipped = line;
        }
        
        if (clipped.length > 0 && block) {
            block(index, line, clipped);
        }
    }
}

+ (xTextMatchResult *)match:(XCSourceTextRange *)selection invocation:(XCSourceEditorCommandInvocation *)invocation {
    
    NSMutableString *lineText = [NSMutableString string];
    NSMutableString *clippedText = [NSMutableString string];
    
    __block BOOL clipboard;
    
    // enumerate each lines
    [xTextMatcher enumerate:invocation selection:selection lineBlock:^(NSInteger index, NSString *line, NSString *clipped) {
        [lineText appendString:line];
        [clippedText appendString:clipped];
        clipboard = (index == xTextInvalidLine);
    }];
    
    // clipboard result or selected result
    return clipboard ? xTextMatchResult.clipboardResult : [xTextMatchResult resultWithText:lineText clipped:clippedText];
}

@end
