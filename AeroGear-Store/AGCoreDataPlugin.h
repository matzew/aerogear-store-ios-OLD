//
//  AGCoreDataPlugin.h
//  AeroGear-Store
//
//  Created by Matthias Wessendorf on 12/14/12.
//  Copyright (c) 2012 Matthias Wessendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AFIncrementalStore.h"
#import "AGAuthenticationModule.h"

@protocol AGIncrementalStoreAdapter <NSObject>

//-(NSURL *) baseURL;
//+(NSString *) modelName;
//+(NSString *) extension;
@end

@interface AGCoreDataPlugin : AFIncrementalStore<AGIncrementalStoreAdapter>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSString *modelName;
@property (nonatomic) NSURL *baseURL;



+ (AGCoreDataPlugin *)sharedClient:(id<AGAuthenticationModule>) authenticationModule;

@end
