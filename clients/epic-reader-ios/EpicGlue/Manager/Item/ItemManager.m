// Class managing item lists and synchronizing them with the server
//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "ItemManager.h"
#import "ItemList.h"
#import "Item.h"
#import "Settings.h"
#import "DataSource.h"
#import "ItemClient.h"
#import "ItemHashList.h"
#import "SyncItemClient.h"
#import "Subscription.h"
#import "Service.h"
#import "HUDNotification.h"
#import "SubscriptionManager.h"
#import "SubscriptionList.h"
#import "Source.h"
#import "Counter.h"
#import "CurrentSession.h"
#import "APIError.h"
#import "ARAnalytics.h"

@interface ItemManager ()
@property(nonatomic, strong) dispatch_queue_t itemManagerQueue;
@end

@implementation ItemManager

+ (instancetype)instance
{
    static ItemManager *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        _instance.readItems = [[ItemHashList alloc] init];
        _instance.currentItemList = [[ItemList alloc] init];
        _instance.dataSource = [[DataSource alloc] init];

        _instance.itemManagerQueue = dispatch_queue_create("com.epicglue.item_manager", DISPATCH_QUEUE_SERIAL);

        CurrentSession *session = [CurrentSession instance];
        if (session.selectedTopBarOption == 0) {
            _instance.selectedTab = SelectedTabUnread;
        } else {
            _instance.selectedTab = SelectedTabGlued;
        }

        if (session.selectedSubscriptionId != 0) {
            Subscription *s = [Subscription subscriptionWithSubscriptionId:session.selectedSubscriptionId];
            [_instance setNewDataSourceWithSubscription:s];
        } else if (session.selectedServiceShortName != nil) {
            Service *s = [[Service alloc] initWithJSON:@{@"short_name": session.selectedServiceShortName}];
            [_instance setNewDataSourceWithService:s];
        } else {
            [_instance.dataSource setOnlyNotRead:YES];
        }
    });

    return _instance;
}

- (int)count
{
    return (int) [self.currentItemList count];
}

- (void)load
{
    [[ItemClient instance] getItems:[self.dataSource buildFilter]
                          onSuccess:nil
                          onFailure:nil
                             notify:nil];
}

- (void)loadDataSource:(DataSource *)dataSource
{
    [[ItemClient instance] getItems:[dataSource buildFilter]
                          onSuccess:nil
                          onFailure:nil
                             notify:nil];
}


- (void)loadEarlier
{
    [self.dataSource setAfter:nil];
    [self.dataSource setBefore:[[self.currentItemList firstItem] createdAt]];
    [self load];

    [ARAnalytics event:EVGetNewerItems];
}

- (void)loadLater
{
    dispatch_async(self.itemManagerQueue, ^{
        [self.dataSource setAfter:[[self.currentItemList lastItem] createdAt]];
        [self.dataSource setBefore:nil];
        [self load];

        [ARAnalytics event:EVGetOlderItems];
    });
}

- (void)readAll
{
    [[HUDNotification instance] displayMessage:@"Marking all items as read"];

    [[SyncItemClient instance] readAll:self.dataSource
                             onSuccess:^(JSONResponse *json) {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:ENItems object:[[ItemList alloc] init]];
                                 [ARAnalytics event:EVReadAll];

                                 [[HUDNotification instance] hide];
                             }
                             onFailure:^(APIError *error) {
                                 DDLogError(@"failed to sync items");

                                 [[HUDNotification instance] hide];
                                 [[HUDNotification instance] displayErrorMessage:@"Request Failed"];
                             }
                                notify:nil];
}

- (void)glueItem:(Item *)item onComplete:(void (^)(APIError *error))complete
{
    [[HUDNotification instance] displayMessage:@"Gluing Item"];

    [[SyncItemClient instance] glueItem:item
                              onSuccess:^(JSONResponse *json) {
                                  [ARAnalytics event:EVGlueItem];
                                  [[HUDNotification instance] hide];

                                  if (complete) {
                                      complete(nil);
                                  }
                              }
                              onFailure:^(APIError *error) {
                                  DDLogError(@"Failed to glue item");

                                  [[HUDNotification instance] hide];
                                  [[HUDNotification instance] displayErrorMessage:@"Request Failed"];

                                  if (complete) {
                                      complete(error);
                                  }
                              } notify:nil];
}

- (void)unglueItem:(Item *)item onComplete:(void (^)(APIError *error))complete
{
    [[HUDNotification instance] displayMessage:@"Ungluing item"];

    [[SyncItemClient instance] unglueItem:item
                                onSuccess:^(JSONResponse *json) {
                                    [ARAnalytics event:EVUnglueItem];
                                    [[HUDNotification instance] hide];

                                    if (complete) {
                                        complete(nil);
                                    }
                                }
                                onFailure:^(APIError *error) {
                                    DDLogError(@"Failed to unglue item");

                                    [[HUDNotification instance] hide];
                                    [[HUDNotification instance] displayErrorMessage:@"Request Failed"];

                                    if (complete) {
                                        complete(error);
                                    }
                                }
                                   notify:nil];
}

- (void)addReadItem:(Item *)item
{
    if (item == nil || item.itemId == nil) {
        return;
    }

    [self.readItems addHash:item.itemId];

    DDLogDebug(@"Read %@", item.itemId);

    // Decrement counters
    BOOL hasUpdated = NO;

    for (NSNumber *key in item.subs) {
        for (Service *service in [[[SubscriptionManager instance] usersList] list]) {
            for (Source *source in service.sources) {
                for (Subscription *subscription in source.subscriptions) {
                    if (subscription.subscriptionId == [key integerValue]) {
                        subscription.counter.value = subscription.counter.value - 1;
                        hasUpdated = YES;

                        break;
                    }
                }
            }
        }
    }

    if (hasUpdated) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ENCounters object:nil];
    }
}

- (void)syncReadItems
{
    dispatch_async(self.itemManagerQueue, ^{
        if ([self.readItems count] == 0) {
            return;
        }

        NSArray *synced = [[NSMutableArray alloc] initWithArray:[self.readItems getList] copyItems:YES];

        [[SyncItemClient instance] sync:self.readItems
                              onSuccess:^(JSONResponse *json) {
                                  DDLogDebug(@"Synced read items");

                                  for (NSString *hash in synced) {
                                      [self.dataSource removeItemHashFromBlacklist:hash];

                                      [self.readItems removeHash:hash];
                                  }

                                  [ARAnalytics event:EVReadItem];
                              }
                              onFailure:^(APIError *error) {
                                  DDLogWarn(@"Failed to sync read items");
                              }
                                 notify:nil];
    });
}

- (void)setNewDataSource
{
    DataSource *ds = [[DataSource alloc] init];
    [ds setOnlyNotRead:NO];
    [ds setOnlyPinned:NO];

    if (self.selectedTab == SelectedTabUnread) {
        [ds setOnlyNotRead:YES];
        [ds setBlacklistItemIDs:[[self.readItems getList] mutableCopy]];
    } else if (self.selectedTab == SelectedTabGlued) {
        [ds setOnlyPinned:YES];
        [ds setBlacklistItemIDs:[@[] mutableCopy]];
    }

    [self setDataSource:ds];
}

- (void)setNewDataSourceWithSubscription:(Subscription *)subscription
{
    [self setNewDataSource];
    [self.dataSource addSubscription:subscription];
}

- (void)setNewDataSourceWithService:(Service *)service
{
    [self setNewDataSource];
    [self.dataSource addService:service];
}

- (void)setSelectedTab:(SelectedTab)newSelectedTab
{
    _selectedTab = newSelectedTab;

    [self.dataSource setBefore:nil];
    [self.dataSource setAfter:nil];
    [self.dataSource setOnlyNotRead:NO];
    [self.dataSource setOnlyPinned:NO];

    if (_selectedTab == SelectedTabUnread) {
        [self.dataSource setOnlyNotRead:YES];
        [self.dataSource setBlacklistItemIDs:[[self.readItems getList] mutableCopy]];
    } else if (_selectedTab == SelectedTabGlued) {
        [self.dataSource setOnlyPinned:YES];
        [self.dataSource setBlacklistItemIDs:[@[] mutableCopy]];
    }
}

- (void)setCurrentItemList:(ItemList *)currentItemList
{
    _currentItemList = currentItemList;
}

@end