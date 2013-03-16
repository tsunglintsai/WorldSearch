//
//  WordSearchTVC.m
//  WorldSearch
//
//  Created by Daniela on 3/15/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "WordSearchTVC.h"
#import "DataMigrator.h"
#import "Word.h"
#import "CoreDataHelper.h"

@interface WordSearchTVC ()

@end

@implementation WordSearchTVC


- (void)viewDidLoad{
    [super viewDidLoad];
    if(NO) {
        [DataMigrator migrateData];    
    }
    
    if(![DataMigrator isDataBaseExist]){
        [DataMigrator copyDataBaseFromBundle];
    }
    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
        self.managedObjectContext = context;
        
        NSDate *start = [NSDate date];

        NSString *searchString = @"rut";
        [self.managedObjectContext performBlockAndWait:^{
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
            request.sortDescriptors = @[];
            request.predicate = [NSPredicate predicateWithFormat:@"prefix = %@  AND content BEGINSWITH[n] %@",[searchString substringToIndex:1],searchString];
            NSError *error;
            NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
            if(error) NSLog(@"%@",error);
            for(Word *word in matches){
                NSLog(@"%@",word.content);
            }
        }];
        
        
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        
        NSLog(@"Found Prefix %@ in Execution Time: %f sec", searchString, executionTime);
        
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"WordCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Word *word = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = word.content;
    return cell;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
        request.sortDescriptors = @[];
        request.predicate = [NSPredicate predicateWithFormat:@"content != nil"];
        [request setFetchLimit:2000];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}


#pragma mark - SearchViewControl Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSInteger searchOption = controller.searchBar.selectedScopeButtonIndex;
    return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString* searchString = controller.searchBar.text;
    return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    [self.fetchedResultsController.fetchRequest setPredicate:nil];
    [self performFetch];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString*)searchString searchScope:(NSInteger)searchOption {
    if([searchString length]>0){
        [self.fetchedResultsController.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"prefix = %@  AND content BEGINSWITH[n] %@",[searchString substringToIndex:1],searchString]];
        [self performFetch];
    }else{
        [self.fetchedResultsController.fetchRequest setPredicate:nil];
    }
    return YES;
}

@end
