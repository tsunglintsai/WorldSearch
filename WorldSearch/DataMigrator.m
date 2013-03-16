//
//  DataMigrator.m
//  WorldSearch
//
//  Created by Daniela on 3/15/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "DataMigrator.h"
#import "Word+Create.h"
#import "CoreDataHelper.h"
#import "MyUIManagedDocument.h"

@implementation DataMigrator

+(void)migrateData{
    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
        [context setUndoManager:nil];
        NSLog(@"document created");
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wordsEn" ofType:@"txt"];
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        if (myData) {
            // do something useful
            NSString *wordsStrign = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] ;
            NSArray *wordList = [wordsStrign componentsSeparatedByString:@"\n"];
            [context performBlockAndWait:^{
                for(NSString *word in wordList){
                    if([word length]>3){
                        [Word wordWithContent:word inManagedObjectContext:context];
                        NSLog(@"%@",word);
                    }
                }
            }];
            NSError *error;
            [context save:&error];
            [[CoreDataHelper sharedInstance]saveDocument];
            NSLog(@"error:%@",error);
        }
    }];
}

+(BOOL) isDataBaseExist{
    return [[[self class]dataBaseURL] checkResourceIsReachableAndReturnError:nil];
}

+(NSURL*)dataBaseURL {
    NSURL *docURL = [[[[NSFileManager alloc]init] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    docURL = [docURL URLByAppendingPathComponent:@"core data"];
    docURL = [docURL URLByAppendingPathComponent:@"StoreContent"];
    docURL = [docURL URLByAppendingPathComponent:@"CoreData"];
    docURL = [docURL URLByAppendingPathExtension:@"sqlite"];
    return docURL;
}

+(NSURL*)dataBaseFolderURL {
    NSURL *docURL = [[[[NSFileManager alloc]init] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    docURL = [docURL URLByAppendingPathComponent:@"core data"];
    docURL = [docURL URLByAppendingPathComponent:@"StoreContent"];
    return docURL;
}

+(BOOL)isDataBaseExistInBundle{
    return [[[self class]dataBaseURLinBundle] checkResourceIsReachableAndReturnError:nil];    
}

+(NSURL*)dataBaseURLinBundle{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CoreData" ofType:@"sqlite"];
    return [NSURL fileURLWithPath:filePath];
}

+(void) copyDataBaseFromBundle{
    [[[NSFileManager alloc]init] createDirectoryAtURL:[[self class]dataBaseFolderURL] withIntermediateDirectories:YES attributes:nil error:nil];
    [[[NSFileManager alloc]init] copyItemAtURL:[[self class]dataBaseURLinBundle] toURL:[[self class]dataBaseURL] error:nil];
}

@end
