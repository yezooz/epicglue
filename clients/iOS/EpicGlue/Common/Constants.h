// All system constants
//
// Created by Marek Mikuliszyn on 22/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Constants-Secret.h"

#define LoadMoreWhenLessThan 30

#define Instagram @"instagram"
#define Twitter @"twitter"
#define ProductHunt @"product_hunt"
#define Kickstarter @"kickstarter"
#define HackerNews @"hacker_news"
#define Reddit @"reddit"
#define Tumblr @"tumblr"
#define Facebook @"fb"
#define YouTube @"yt"
#define RSS @"rss"

typedef NS_ENUM(NSInteger, SelectedTab)
{
    SelectedTabUnread,
    SelectedTabGlued
};

typedef NS_ENUM(NSInteger, MediaSize)
{
    MediaSizeSmall,
    MediaSizeMedium,
    MediaSizeLarge,
    MediaSizeUnknown
};

typedef NS_ENUM(NSInteger, SelectedServiceAction)
{
    SelectedServiceActionSubscribe,
    SelectedServiceActionUnsubscribe,
    SelectedServiceActionDisconnect
};

typedef NS_ENUM(NSInteger, SubscriptionListMode)
{
    SubscriptionListModeUnread,
    SubscriptionListModeGlued,
    SubscriptionListModeManage,
    SubscriptionListModeAdd
};

// Keys
static NSString *const kCurrentUser = @"kCurrentUser";
static NSString *const kUserToken = @"kUserToken";
static NSString *const kSelectedSource = @"kSelectedSource";
static NSString *const kSelectedService = @"kSelectedService";
static NSString *const kSelectedSubscription = @"kSelectedSubscription";
static NSString *const kOnboardingComplete = @"kOnboardingComplete";
static NSString *const kSelectedTopBarOption = @"kSelectedTopBarOption";
static NSString *const kSelectedSideBarOption = @"kSelectedSideBarOption";
static NSString *const kReadItemIds = @"kReadItemIds";
static NSString *const kSubscriptionListMode = @"kSubscriptionListMode";
static NSString *const kNeverHadSubscription = @"kNeverHadSubscription";

// Epic Notifications
static NSString *const ENItems = @"ENItems";
static NSString *const ENOlderItems = @"ENOlderItems";
static NSString *const ENNewerItems = @"ENNewerItems";
static NSString *const ENCounters = @"ENCounters";
static NSString *const ENSubscriptionList = @"ENSubscriptionsList";
static NSString *const ENSubscribed = @"ENSubscribed";
static NSString *const ENUnsubscribed = @"ENUnsubscribed";
static NSString *const ENReadAllItems = @"ENReadAllItems";
static NSString *const ENRead = @"ENRead";
static NSString *const ENGlued = @"ENGlued";
static NSString *const ENUnglued = @"ENUnglued";
static NSString *const ENRegisteredDevice = @"ENRegisteredDevice";
static NSString *const ENLoggedIn = @"ENLoggedIn";
static NSString *const ENLogout = @"ENLogout";
static NSString *const ENRefreshedProfile = @"ENRefreshedProfile";
static NSString *const ENPaymentsAcknowledged = @"ENPaymentsAcknowledged";

// Epic Events
static NSString *const EVAppOpen = @"open.app";
static NSString *const EVAppClose = @"close.app";
static NSString *const EVAppReopen = @"re.open.app";
static NSString *const EVLogin = @"login";
static NSString *const EVGetItems = @"get.items";
static NSString *const EVGetNewerItems = @"newer.get.items";
static NSString *const EVGetOlderItems = @"older.get.items";
static NSString *const EVReadAll = @"all.read.items";
static NSString *const EVReadItem = @"read.items";
static NSString *const EVGlueItem = @"glue.items";
static NSString *const EVUnglueItem = @"unglue.items";
static NSString *const EVReachedEndOfStream = @"eos.items";
static NSString *const EVOpenImage = @"image.click.items";
static NSString *const EVOpenVideo = @"video.click.items";
static NSString *const EVOpenLink = @"link.click.items";
static NSString *const EVFeedback = @"feedback";
static NSString *const EVOpenInSystemBrowser = @"system.link.click.items";
static NSString *const EVSelectAll = @"all.select";
static NSString *const EVSelectService = @"service.select";
static NSString *const EVSelectSubscription = @"subscription.select";
static NSString *const EVSearchUser = @"user.search";
static NSString *const EVSearchTag = @"tag.search";
static NSString *const EVSearchService = @"service.search";
static NSString *const EVSearch = @"search";
static NSString *const EVSubscribe = @"subscribe";
static NSString *const EVUnsubscribe = @"unsubscribe";
static NSString *const EVPurchase = @"purchase";
static NSString *const EVPurchaseCancel = @"cancel.purchase";
static NSString *const EVPurchaseRestore = @"restore.purchase";
static NSString *const EVPurchaseOpen = @"open.purchase";
static NSString *const EVPurchaseStart = @"start.purchase";
static NSString *const EVPurchaseAcknowledged = @"ack.purchase";
static NSString *const EVPurchasesAcknowledged = @"all.ack.purchase";