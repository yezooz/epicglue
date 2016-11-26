//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "ItemClient.h"
#import "ItemList.h"
#import "APIError.h"
#import "Settings.h"
#import "JSONResponse.h"
#import "HUDNotification.h"
#import "ARAnalytics.h"


@implementation ItemClient

+ (instancetype)instance
{
    static ItemClient *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (void)getItems:(NSString *)query
       onSuccess:(void (^)(ItemList *items))success
       onFailure:(void (^)(APIError *error))failure
          notify:(id <Notification>)notification
{
    [[HUDNotification instance] displayMessage:@"Get Items"];

    [self GET:[self getURLWithSuffix:[NSString stringWithFormat:@"items?q=%@", query]]
    onSuccess:^(JSONResponse *json) {
        ItemList *items = [[ItemList alloc] init];
        [items setItems:json.dict[@"items"]];

        if ([query rangeOfString:@"before:"].location != NSNotFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ENNewerItems object:items];
            [ARAnalytics event:EVGetNewerItems];
        } else if ([query rangeOfString:@"after:"].location != NSNotFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ENOlderItems object:items];
            [ARAnalytics event:EVGetOlderItems];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:ENItems object:items];
            [ARAnalytics event:EVGetItems];
        }

        if (success != nil) {
            success(items);
        }

        [[HUDNotification instance] hide];
    }
    onFailure:^(APIError *error) {
        DDLogError(@"Failed %@", error.localizedDescription);

        [[HUDNotification instance] hide];
        [[HUDNotification instance] displayErrorMessage:@"Request Failed"];

        // Empty list
        [[NSNotificationCenter defaultCenter] postNotificationName:ENItems object:[[ItemList alloc] init]];

        if (failure != nil) {
            failure(error);
        }
    }
       notify:notification];
}

@end