// Sync read items
//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "APIClient.h"
#import "SyncableItemList.h"
#import "Item.h"

@class ItemHashList;
@class DataSource;


@interface SyncItemClient : APIClient <SyncableItemList>

+ (instancetype)instance;

- (NSURL *)getURLWithDS:(DataSource *)ds;

- (void)readAll:(DataSource *)ds
      onSuccess:(void (^)(JSONResponse *json))success
      onFailure:(void (^)(APIError *error))failure
         notify:(id <Notification>)notification;

- (void)glueItem:(Item *)item
       onSuccess:(void (^)(JSONResponse *json))success
       onFailure:(void (^)(APIError *error))failure
          notify:(id <Notification>)notification;

- (void)unglueItem:(Item *)item
         onSuccess:(void (^)(JSONResponse *json))success
         onFailure:(void (^)(APIError *error))failure
            notify:(id <Notification>)notification;

@end