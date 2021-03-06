//
//  Library.h
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Library : NSObject

@property (nonatomic, retain) NSMutableArray *elements;

+ (Library *) sharedLibrary;
+ (NSString *) applicationDocumentsDirectory;

- (void) save;

@end
