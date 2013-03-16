//
//  Word.h
//  WorldSearch
//
//  Created by Daniela on 3/15/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * prefix;

@end
