//
//  AGCoreDataPlugin.h
//  AeroGear-Store
//
//  Created by Matthias Wessendorf on 12/14/12.
//  Copyright (c) 2012 Matthias Wessendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AGIncrementalStore.h"

#import "AGAuthenticationModule.h"


@interface AGCoreDataPlugin : AGIncrementalStore<AGIncrementalStoreAdapter>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) NSString *modelName;
@property (nonatomic) NSURL *baseURL;



+ (AGCoreDataPlugin *)sharedClient:(id<AGAuthenticationModule>) authenticationModule;

@end
