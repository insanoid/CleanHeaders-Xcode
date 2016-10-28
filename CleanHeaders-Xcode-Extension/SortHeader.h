//
//  SortHeader.h
//  CleanHeaders-Xcode
//
//  Created by Karthik on 28/10/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

static inline NSArray *formatSelectionLines(NSArray *sourceLines) {
    
    NSMutableArray *lines = [[NSMutableArray alloc] initWithArray:sourceLines];
    
    // Let's assume all header files start with an #import, #include, @import,
    // import.
    NSString *traditionalImportPrefix = @"#import";
    NSString *frameworkImportPrefix = @"@import";
    NSString *traditionalIncludePrefix = @"#include";
    NSString *swiftPrefix = @"import";
    
    // Position of the first and last line of header, to be used for repalcement
    // of header content.
    NSInteger __block initalIndex = -1;
    NSInteger __block lastIndex = -1;
    BOOL __block endOfFileWithNewLine = YES;  // Indicates if the selection's last
    // line was a new line.
    NSMutableArray *headerRows = [[NSMutableArray alloc] init];
    
    // Go through each of the line and identify any header elements.
    [lines enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx,
                                        BOOL *_Nonnull stop) {
        NSString *cleansedLine =
        [string stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        BOOL isLineHeader = [cleansedLine hasPrefix:traditionalImportPrefix] ||
        [cleansedLine hasPrefix:traditionalIncludePrefix] ||
        [cleansedLine hasPrefix:frameworkImportPrefix] ||
        [cleansedLine hasPrefix:swiftPrefix];
        
        // If the line is a header and no header element has been detected so far,
        // mark this as the start of the header segment.
        if (isLineHeader && initalIndex < 0) {
            initalIndex = idx;
        } else if (initalIndex >= 0 && !(isLineHeader || ![cleansedLine length])) {
            // If the inital index has been set AND the line is not a header or a new
            // line, then this is to be marked as the end of header segment and
            // enumeration has to be stopped.
            lastIndex = idx;
            *stop = YES;
        }
        
        if (initalIndex >= 0 && lastIndex < 0) {
            // If the inital index is already set and we are in this condition it
            // means we are parsing the header. Check for duplicates and ensure that
            // it is not a new line and then add to the header rows array.
            if (![headerRows containsObject:[cleansedLine stringByAppendingString:@"\n"]] &&
                [cleansedLine length]) {
                cleansedLine = [cleansedLine stringByAppendingString:@"\n"];
                [headerRows addObject:cleansedLine];
            }
        }
        
        // Reached the end of the selection or a file. (In case of a selection or a
        // header only file)
        if (idx >= lines.count - 1) {
            lastIndex = idx + 1;
            
            // If the end was a header and not a new line and also marked the end of
            // selection, a new line would look odd.
            if ([cleansedLine length]) {
                endOfFileWithNewLine = NO;
            }
        }
    }];
    
    // If both the indices are set it means that we have a header section in the
    // file and it needs replacing after sorting.
    if (lastIndex >= 0 && initalIndex >= 0) {
        [headerRows sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        // Add a new line to make it look clean (if needed, if only header is selected then don't)
        // This is a flawed logic, but cannot think of a perfect way to do it right now.
        if (endOfFileWithNewLine && !(headerRows.count == lines.count)) {
            [headerRows addObject:@"\n"];
        } else if((headerRows.count == lines.count) && headerRows.count) {
            // Avoid extra line if one selects only the header and keeps sorting them.
            NSString *lastHeader = [headerRows lastObject];
            lastHeader = [lastHeader stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [headerRows replaceObjectAtIndex:headerRows.count - 1 withObject:lastHeader];
        }
        // replace it in the array of all lines.
        [lines replaceObjectsInRange:NSMakeRange(initalIndex,
                                                 (lastIndex - initalIndex))
                withObjectsFromArray:headerRows];
    }
    
    return lines;
}

static inline NSString *formatSelection(NSString *content) {
    
    // Convert the entire source into an array based on new lines.
    // Hence the imports have to be alteast in new line to work.
    return [formatSelectionLines([content componentsSeparatedByString:@"\n"])
            componentsJoinedByString:@""];
}
