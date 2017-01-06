// Client responsible for fetching ItemList from the server, latest items, earlier and later.
//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "APIClient.h"

@class ItemList;
@class Item;

@interface ItemClient : APIClient

+ (instancetype)instance;

- (void)getItems:(NSString *)query
       onSuccess:(void (^)(ItemList *items))success
       onFailure:(void (^)(APIError *error))failure
          notify:(id <Notification>)notification;

@end