// Syncs list of read items (in ItemHashList) with /items/read endpoint
//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "SyncItemClient.h"
#import "ItemHashList.h"
#import "Payload.h"
#import "DataSource.h"


@implementation SyncItemClient

+ (instancetype)instance
{
    static SyncItemClient *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (NSURL *)getURLWithDS:(DataSource *)ds
{
    return [self getURLWithSuffix:[NSString stringWithFormat:@"items/read?q=%@", [ds buildFilter]]];
}

- (void)sync:(ItemHashList *)items
     success:(void (^)(JSONResponse *json))success
     failure:(void (^)(APIError *error))failure
{
    [self sync:items onSuccess:success onFailure:failure notify:nil];
}

- (void)sync:(ItemHashList *)items
   onSuccess:(void (^)(JSONResponse *json))success
   onFailure:(void (^)(APIError *error))failure
      notify:(id <Notification>)notification
{
    DataSource *ds = [[DataSource alloc] init];
    ds.itemIDs = [NSMutableArray arrayWithArray:[items getList]];

    [self POST:[self getURLWithDS:ds] withPayload:nil onSuccess:success onFailure:failure notify:notification];
}

- (void)readAll:(DataSource *)ds
      onSuccess:(void (^)(JSONResponse *json))success
      onFailure:(void (^)(APIError *error))failure
         notify:(id <Notification>)notification
{
    [self POST:[self getURLWithDS:ds] withPayload:nil onSuccess:success onFailure:failure notify:notification];
}

- (void)glueItem:(Item *)item
       onSuccess:(void (^)(JSONResponse *json))success
       onFailure:(void (^)(APIError *error))failure
          notify:(id <Notification>)notification
{
    DataSource *ds = [[DataSource alloc] init];
    [ds addItem:item];

    NSURL *url = [self getURLWithSuffix:[NSString stringWithFormat:@"items/glue?q=%@", [ds buildFilter]]];
    [self POST:url withPayload:nil onSuccess:success onFailure:failure notify:notification];
}

- (void)unglueItem:(Item *)item
         onSuccess:(void (^)(JSONResponse *json))success
         onFailure:(void (^)(APIError *error))failure
            notify:(id <Notification>)notification
{
    DataSource *ds = [[DataSource alloc] init];
    [ds addItem:item];

    NSURL *url = [self getURLWithSuffix:[NSString stringWithFormat:@"items/glue?q=%@", [ds buildFilter]]];
    [self DELETE:url withPayload:nil onSuccess:success onFailure:failure notify:notification];
}

@end