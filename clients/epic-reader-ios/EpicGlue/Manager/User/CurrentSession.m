//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "CurrentSession.h"

@implementation CurrentSession

+ (instancetype)instance
{
    static CurrentSession *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            // Force different token
            // User: 3
//            [defaults setObject:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjN9.vadcNxZayE24VrIigrGFGSQR-QtznGnvRHjR2Kxkiv4" forKey:kUserToken];

            _instance.currentUser = [defaults objectForKey:kCurrentUser];
            _instance.userToken = [defaults stringForKey:kUserToken];

            if ([defaults integerForKey:kSelectedSource] == (NSInteger) @0) {
                _instance.selectedSourceId = 0;
            } else {
                _instance.selectedSourceId = (NSUInteger) [defaults integerForKey:kSelectedSource];
            }

            if ([defaults stringForKey:kSelectedService] != nil) {
                _instance.selectedServiceShortName = [defaults stringForKey:kSelectedService];
            }

            if ([defaults integerForKey:kSelectedSubscription] == (NSInteger) @0) {
                _instance.selectedSubscriptionId = 0;
            } else {
                _instance.selectedSubscriptionId = (NSUInteger) [defaults integerForKey:kSelectedSubscription];
            }

            if ([defaults integerForKey:kSelectedTopBarOption] == SelectedTabUnread) {
                _instance.selectedTopBarOption = SelectedTabUnread;
            } else {
                _instance.selectedTopBarOption = (SelectedTab) [defaults integerForKey:kSelectedTopBarOption];
            }

            if ([defaults integerForKey:kSelectedSideBarOption] == (NSInteger) @0) {
                _instance.selectedSideBarOption = 0;
            } else {
                _instance.selectedSideBarOption = (NSUInteger) [defaults integerForKey:kSelectedSideBarOption];
            }

            _instance.onboardingComplete = [defaults boolForKey:kOnboardingComplete];

            if (![defaults arrayForKey:kReadItemIds]) {
                _instance.readItemIds = [NSArray array];
            } else {
                _instance.readItemIds = [defaults arrayForKey:kReadItemIds];
            }

            if (![defaults objectForKey:kSubscriptionListMode]) {
                _instance.subscriptionListMode = SubscriptionListModeUnread;
            } else {
                _instance.subscriptionListMode = (SubscriptionListMode) [defaults integerForKey:kSubscriptionListMode];
            }

            if (![defaults objectForKey:kNeverHadSubscription]) {
                _instance.neverHadSubscription = YES;
            } else {
                _instance.neverHadSubscription = [defaults boolForKey:kNeverHadSubscription];
            }
        }
    });

    return _instance;
}

- (NSDictionary *)currentUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentUserJSON = [defaults stringForKey:kCurrentUser];

    if (!self.currentUserJSON) {
        return nil;
    }

    NSError *error = nil;
    NSData *data = [self.currentUserJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:(NSJSONReadingOptions) kNilOptions
                                                                   error:&error];

    return jsonResponse;
}

- (void)setCurrentUser:(NSDictionary *)currentUser
{
    NSError *error = nil;
    NSData *json;

    if ([NSJSONSerialization isValidJSONObject:currentUser]) {
        json = [NSJSONSerialization dataWithJSONObject:currentUser options:NSJSONWritingPrettyPrinted error:&error];

        if (json != nil && error == nil) {
            self.currentUserJSON = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.currentUserJSON forKey:kCurrentUser];
        }
    }
}

- (void)setUserToken:(NSString *)userToken
{
    _userToken = userToken;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userToken forKey:kUserToken];
}

- (void)setSelectedSourceId:(NSInteger)selectedSourceId
{
    _selectedSourceId = selectedSourceId;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(NSInteger) selectedSourceId forKey:kSelectedSource];
}

- (void)setSelectedServiceShortName:(NSString *)selectedServiceShortName
{
    _selectedServiceShortName = selectedServiceShortName;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedServiceShortName forKey:kSelectedService];
}

- (void)setSelectedSubscriptionId:(NSInteger)selectedSubscriptionId
{
    _selectedSubscriptionId = selectedSubscriptionId;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(NSInteger) selectedSubscriptionId forKey:kSelectedSubscription];
}

- (void)setSelectedTopBarOption:(SelectedTab)selectedTopBarOption
{
    _selectedTopBarOption = selectedTopBarOption;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:selectedTopBarOption forKey:kSelectedTopBarOption];
}

- (void)setSelectedSideBarOption:(NSInteger)selectedSideBarOption
{
    _selectedSideBarOption = selectedSideBarOption;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:selectedSideBarOption forKey:kSelectedSideBarOption];
}

- (void)setReadItemIds:(NSArray *)readItemIds
{
    _readItemIds = readItemIds;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:readItemIds forKey:kReadItemIds];
}

- (void)setOnboardingComplete:(BOOL)onboardingComplete
{
    _onboardingComplete = onboardingComplete;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:onboardingComplete forKey:kOnboardingComplete];
}

- (void)setSubscriptionListMode:(SubscriptionListMode)subscriptionListMode
{
    _subscriptionListMode = subscriptionListMode;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:subscriptionListMode forKey:kSubscriptionListMode];
}

- (void)setNeverHadSubscription:(BOOL)neverHadSubscription
{
    _neverHadSubscription = neverHadSubscription;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:neverHadSubscription forKey:kNeverHadSubscription];
}

@end