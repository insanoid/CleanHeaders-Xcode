//
//  NSObject_Extension.m
//  CleanHeaders
//
//  Created by Karthik on 07/10/2015.
//  Copyright © 2015 Karthikeya Udupa K M. All rights reserved.
//


#import "NSObject_Extension.h"
#import "CleanHeaders.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[CleanHeaders alloc] initWithBundle:plugin];
        });
    }
}
@end
