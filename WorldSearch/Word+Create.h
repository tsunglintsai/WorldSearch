//
//  Word+Create.h
//  WorldSearch
//
//  Created by Daniela on 3/15/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Word.h"

@interface Word (Create)

+ (Word *)wordWithContent:(NSString *)content
   inManagedObjectContext:(NSManagedObjectContext *)context;
@end
