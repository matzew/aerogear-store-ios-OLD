//
//  AGCoreDataPlugin.m
//  AeroGear-Store
//
//  Created by Matthias Wessendorf on 12/14/12.
//  Copyright (c) 2012 Matthias Wessendorf. All rights reserved.
//

#import "AGCoreDataPlugin.h"

#import "AGIncrementalStore.h"
#import "AGIncrementalStoreHttpClient.h"

@implementation AGCoreDataPlugin {
    
}


@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

// hack??
@synthesize baseURL   = _baseURL;
@synthesize modelName = _modelName;


///// init with........ model, url, extension(?).....
// return it from here.... the awful "protocol"

//Idally user does sharedClient:auth base....... ONCE.... and can just get the damn context of ...

+ (AGCoreDataPlugin *)sharedClient:(id<AGAuthenticationModule>) authenticationModule {

    static AGCoreDataPlugin *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AGCoreDataPlugin alloc] init]; // iniot with.......
        _authenticationModule = authenticationModule;
    });

    return _sharedClient;
}


#pragma mark - Core Data

//static:
id<AGAuthenticationModule> _authenticationModule;

// it's a getter of AFIncStore...
- (id <AFIncrementalStoreHTTPClient>)HTTPClient {
    
    // THIS needs to be initialized ...............
    return [AGIncrementalStoreHttpClient clientFor:[self baseURL] authModule:_authenticationModule];
}


#pragma mark - Core Data

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[self mo] withExtension:[self ]];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    [__persistentStoreCoordinator addPersistentStoreWithType:[AGIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
//    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[__persistentStoreCoordinator addPersistentStoreWithType:[SongsIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
//    NSError *error = nil;
//    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//
//    NSLog(@"SQLite URL: %@", [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Songs.sqlite"]);
//    
    return __persistentStoreCoordinator;
}

@end
