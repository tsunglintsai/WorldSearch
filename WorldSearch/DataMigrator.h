//
//  DataMigrator.h
//  WorldSearch
//
//  Created by Daniela on 3/15/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataMigrator : NSObject
+(void) migrateData;
+(BOOL) isDataBaseExist;
+(NSURL*) dataBaseURL;
+(BOOL) isDataBaseExistInBundle;
+(NSURL*) dataBaseURLinBundle;
+(void) copyDataBaseFromBundle;
@end
