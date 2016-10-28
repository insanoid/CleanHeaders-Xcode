//
//  xTextModifier.m
//  xTextHandler
//
//  Created by cyan on 16/6/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "xTextModifier.h"
#import "xTextMatcher.h"
#import <AppKit/AppKit.h>

@implementation xTextModifier

+ (void)select:(XCSourceEditorCommandInvocation *)invocation
       handler:(xTextHandlerBlock)handler
handlerForAllContent:(xLineHandlerBlock)allContentHandler {
    
    
    // No selections but the file has lines.
    if ([self isNothingSelected:invocation] && invocation.buffer.lines) {
        NSArray *formattedContentLines = allContentHandler(invocation.buffer.lines);
        [invocation.buffer.lines removeAllObjects];
        [invocation.buffer.lines addObjectsFromArray: formattedContentLines];
        return;
    }

    // enumerate selections
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        
        // match clipped text
        xTextMatchResult *match = [xTextMatcher match:range invocation:invocation];
        
        if (match.clipboard) { // handle clipboard text
            if (match.text) {
                [[NSPasteboard generalPasteboard] declareTypes:@[NSPasteboardTypeString] owner:nil];
                [[NSPasteboard generalPasteboard] setString:handler(match.text) forType:NSPasteboardTypeString];
            }
            continue;
        }
        
        if (match.text.length == 0) {
            continue;
        }
        
        // handle selected text
        NSMutableArray<NSString *> *texts = [NSMutableArray array];
        [texts addObject:[match.text substringWithRange:match.range]];

        if (texts.count == 0) { // filter empty case
            continue;
        }
        
        NSMutableString *replace = match.text.mutableCopy;
        for (NSString *text in texts) {
            // replace each matched text with handler block
            NSRange textRange = [replace rangeOfString:text];
            if (textRange.location != NSNotFound) { // ensure replace only once
                [replace replaceCharactersInRange:textRange withString:handler(text)];
            }
        }
        
        // separate text to lines using newline charset
        NSArray<NSString *> *lines = [replace componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        // update buffer
        [invocation.buffer.lines replaceObjectsInRange:NSMakeRange(range.start.line, range.end.line-range.start.line+1)
                                  withObjectsFromArray:lines];
        
        range.end = range.start; // cancel selection
    }
}

+ (BOOL)isNothingSelected:(XCSourceEditorCommandInvocation *)invocation {
    
    if (!invocation.buffer.selections.count) {
        return YES;
    }
    
    if (invocation.buffer.selections.count == 1) {
        XCSourceTextRange *selectionRange = [invocation.buffer.selections firstObject];
        if(selectionRange.start.column == selectionRange.end.column &&
           selectionRange.start.line == selectionRange.end.line) {
            return YES;
        }
    }

    return NO;
}

@end
