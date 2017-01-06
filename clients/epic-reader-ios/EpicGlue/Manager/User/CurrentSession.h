// Allows to interact with session
//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Settings.h"

@interface CurrentSession : NSObject

@property(nonatomic) NSDictionary *currentUser;
@property(nonatomic) NSString *currentUserJSON;
@property(nonatomic) NSString *userToken;
@property(nonatomic) NSInteger selectedSourceId;
@property(nonatomic) NSString *selectedServiceShortName;
@property(nonatomic) NSInteger selectedSubscriptionId;
@property(nonatomic) BOOL onboardingComplete;
@property(nonatomic) SelectedTab selectedTopBarOption;
@property(nonatomic) NSInteger selectedSideBarOption;
@property(nonatomic) NSArray *readItemIds;
@property(nonatomic) SubscriptionListMode subscriptionListMode;
@property(nonatomic) BOOL neverHadSubscription;

+ (instancetype)instance;

@end