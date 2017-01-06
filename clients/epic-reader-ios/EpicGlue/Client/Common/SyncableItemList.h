//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class APIError;
@class ItemHashList;

@protocol Notification;

@protocol SyncableItemList <NSObject>

- (void)sync:(ItemHashList *)items
     success:(void (^)(JSONResponse *json))success
     failure:(void (^)(APIError *error))failure;

- (void)sync:(ItemHashList *)items
   onSuccess:(void (^)(JSONResponse *json))success
   onFailure:(void (^)(APIError *error))failure
      notify:(id <Notification>)notification;

@end