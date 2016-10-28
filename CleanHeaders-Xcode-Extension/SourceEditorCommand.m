//
//  SourceEditorCommand.m
//  CleanHeaders-Xcode-Extension
//
//  Created by Karthik on 28/10/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "SortHeader.h"
#import "xTextModifier.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    [xTextModifier select:invocation
                  handler:self.handlers[invocation.commandIdentifier]
     handlerForAllContent:self.handlers[@"all_source"]];
    completionHandler(nil);
}

- (NSDictionary *)handlers {
    static NSDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = @{
                      @"com.karthik.cleanHeader-Xcode":
                          ^NSString *(NSString *text) { return formatSelection(text); },
                      @"all_source":
                          ^NSArray *(NSArray *lines) { return formatSelectionLines(lines); }
                      };
    });
    return _instance;
}
@end
