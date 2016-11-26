// Manage items
//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@class ItemList;
@class ItemHashList;
@class DataSource;
@protocol Notification;
@class Subscription;
@class Service;
@class Item;
@class APIError;

@interface ItemManager : NSObject

@property(atomic) DataSource *dataSource;
@property(nonatomic) ItemList *currentItemList;
@property(atomic) ItemHashList *readItems;

@property(nonatomic) SelectedTab selectedTab;

+ (instancetype)instance;

- (void)load;

- (void)loadDataSource:(DataSource *)dataSource;

- (void)loadEarlier;

- (void)loadLater;

- (void)readAll;

- (void)glueItem:(Item *)item
      onComplete:(void (^)(APIError *error))complete;

- (void)unglueItem:(Item *)item
        onComplete:(void (^)(APIError *error))complete;

- (void)addReadItem:(Item *)item;

- (void)syncReadItems;

- (void)setNewDataSource;

- (void)setNewDataSourceWithSubscription:(Subscription *)subscription;

- (void)setNewDataSourceWithService:(Service *)service;

@end