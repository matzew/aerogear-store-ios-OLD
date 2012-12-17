//
//  AGCoreDataPlugin.m
//  AeroGear-Store
//
//  Created by Matthias Wessendorf on 12/14/12.
//  Copyright (c) 2012 Matthias Wessendorf. All rights reserved.
//

#import "AGCoreDataPlugin.h"

#import "AGIncrementalStoreHttpClient.h"

@implementation AGCoreDataPlugin {
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}


@synthesize managedObjectContext = _managedObjectContext;

//// hack??
//@synthesize baseURL   = _baseURL;
//@synthesize modelName = _modelName;

//NSString* _modelName;
//-(void) setModelName:(NSString *) name {
//    _modelName = name;
//}
//
//-(NSString *) modelName {
//    return _modelName;
//}


///// init with........ model, url, extension(?).....
// return it from here.... the awful "protocol"

//Idally user does sharedClient:auth base....... ONCE.... and can just get the damn context of ...

+ (AGCoreDataPlugin *)sharedClient:(id<AGAuthenticationModule>) authenticationModule model:(NSString *) model baseURL:(NSURL *) baseURL {
    
    // model and url:
    _modelName = model;
    _baseURL = baseURL;



    static AGCoreDataPlugin *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AGCoreDataPlugin alloc] init]; // iniot with.......
        _authenticationModule = authenticationModule;
    });

    return _sharedClient;
}



+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

+ (NSManagedObjectModel *)model {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:_modelName withExtension:@"xcdatamodeld"]];
}


//static:
id<AGAuthenticationModule> _authenticationModule;
NSString *_modelName;
NSURL *_baseURL;

#pragma mark - Core Data


// it's a getter of AFIncStore...
- (id <AFIncrementalStoreHTTPClient>)HTTPClient {
    
    // THIS needs to be initialized ...............
    return [AGIncrementalStoreHttpClient clientFor:_baseURL authModule:_authenticationModule];
}





#pragma mark - Core Data

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self storeCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)objectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[self mo] withExtension:[self ]];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)storeCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self objectModel]];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:[self type] configuration:nil URL:nil options:nil error:nil];
//    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[__persistentStoreCoordinator addPersistentStoreWithType:[SongsIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
//    NSError *error = nil;
//    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//
//    NSLog(@"SQLite URL: %@", [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Songs.sqlite"]);
//    
    return _persistentStoreCoordinator;
}

@end
