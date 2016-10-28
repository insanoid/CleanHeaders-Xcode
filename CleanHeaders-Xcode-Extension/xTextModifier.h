//
//  xTextModifier.h
//  xTextHandler
//
//  Created by cyan on 16/6/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>


/**
 Block for text handling

 @param text text

 @return modified text
 */
typedef NSString * (^xTextHandlerBlock) (NSString *text);
typedef NSArray * (^xLineHandlerBlock) (NSArray *lines);

@interface xTextModifier : NSObject


/**
 Select text with regex

 @param invocation XCSourceEditorCommandInvocation

 @param handler    handler
 @param allContentHandler   handler for entire source code.
 */
+ (void)select:(XCSourceEditorCommandInvocation *)invocation
       handler:(xTextHandlerBlock)handler
handlerForAllContent:(xLineHandlerBlock)allContentHandler;

@end
