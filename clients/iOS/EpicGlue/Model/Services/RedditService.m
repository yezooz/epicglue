//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "RedditService.h"

#import "NSDateFormatter+Custom.h"
#import "Settings.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServiceUserInfo.h"


@implementation RedditService

+ (NSString *)name
{
    return Reddit;
}

- (NSURL *)authUrl
{
    NSString *baseUrl = @"https://www.reddit.com/api/v1/authorize";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&state=eg&duration=permanent&scope=identity+mysubreddits+history+vote", baseUrl,
                                               [self clientId], [self callbackUrl]];

    return [NSURL URLWithString:url];
}

- (void)processResponse:(NSDictionary *)response
{
//    {
//        "access_token": Your access token,
//        "token_type": "bearer",
//        "expires_in": Unix Epoch Seconds,
//        "scope": A scope string,
//        "refresh_token": Your refresh token
//    }

    // TODO: need an object to hold these values

    self.token = response[@"access_token"];
    self.refreshToken = response[@"refresh_token"];
    self.tokenType = response[@"token_type"];
    self.scope = response[@"scope"];
    self.expiresIn = response[@"expires_in"];
}

- (NSDictionary *)toPayload
{
    NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:[self.expiresIn integerValue]];

    return @{
            @"service": @"reddit",
            @"username": self.user[@"username"],
            @"user_id": self.user[@"id"],
            @"token": self.token,
            @"token_refresh": self.refreshToken,
            @"scope": self.scope,
            @"expiry_date": [[NSDateFormatter ISO8601] stringFromDate:expiryDate]
    };
}

- (NSURL *)accessTokenUrl
{
    return [NSURL URLWithString:@"https://www.reddit.com/api/v1/access_token"];
}

- (NSString *)clientId
{
#ifdef DEBUG
    return @"Pmnsdh1MM6Ds7g";
#else
    return @"I9dGOuAyo-tQgw";
#endif
}

- (NSString *)clientSecret
{
#ifdef DEBUG
    return @"";
#else
    return @"";
#endif
}

- (NSString *)callbackUrl
{
    return @"epicglue://reddit";
}

- (void)getUserInfo:(void (^)(ServiceUserInfo *userInfo))success
{
    AFHTTPRequestOperationManager *api = [AFHTTPRequestOperationManager manager];
    [api.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [api.requestSerializer setValue:@"EpicGlue DEV" forHTTPHeaderField:@"User-Agent"];

    [api  GET:@"https://oauth.reddit.com/api/v1/me" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        ServiceUserInfo *userInfo = [[ServiceUserInfo alloc] init];

        // TEMP
        userInfo.userId = responseObject[@"id"];
        userInfo.username = responseObject[@"name"];
        self.user = @{
                @"id": userInfo.userId,
                @"username": userInfo.username
        };

        success(userInfo);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"failed %@", error.localizedDescription);
    }];
}

@end