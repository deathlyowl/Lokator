//
//  Library.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "Library.h"

@implementation Library
@synthesize elements;

- (id)init{
    if (self = [super init]) {
        
        self.elements = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/elements.plist", [Library applicationDocumentsDirectory]]]];
    
        if (!self.elements) self.elements = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (Library *) sharedLibrary
{
    static dispatch_once_t once;
    static Library *sharedLibrary;
    dispatch_once(&once, ^{
        sharedLibrary = [[self alloc] init];
    });
    return sharedLibrary;
}

+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void) save {
    [[NSKeyedArchiver archivedDataWithRootObject:elements] writeToFile:[NSString stringWithFormat:@"%@/elements.plist", [Library applicationDocumentsDirectory]] atomically:YES];
}

@end
