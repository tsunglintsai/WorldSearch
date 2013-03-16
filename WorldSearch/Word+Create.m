//
//  Word+Create.m
//  WorldSearch
//
//  Created by Daniela on 3/15/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Word+Create.h"

@implementation Word (Create)
+ (Word *)wordWithContent:(NSString *)content
   inManagedObjectContext:(NSManagedObjectContext *)context{
    Word *word = nil;
    word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
    word.content = content;
    word.prefix = [content substringToIndex:1];
    return word;
}
@end
