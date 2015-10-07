//
//  CleanHeaders.h
//  CleanHeaders
//
//  Created by Karthik on 07/10/2015.
//  Copyright © 2015 Karthikeya Udupa K M. All rights reserved.
//

#import <AppKit/AppKit.h>

@class CleanHeaders;

static CleanHeaders *sharedPlugin;

/**
 *  Main class to handle Cleaning of header files either by selection and if
 * there is no selection then the whole file.
 */
@interface CleanHeaders : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property(nonatomic, strong, readonly) NSBundle *bundle;
@end