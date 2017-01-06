//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "ProductHuntService.h"
#import "NSDateFormatter+Custom.h"
#import "Settings.h"


@implementation ProductHuntService

+ (NSString *)name
{
    return @"product_hunt";
}

- (NSURL *)authUrl
{
    NSString *baseUrl = @"https://api.producthunt.com/v1/oauth/authorize";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=public+private", baseUrl,
                                               [self clientId], [self callbackUrl]];

    DDLogDebug(@"%@", url);
    return [NSURL URLWithString:url];
}

- (void)processResponse:(NSDictionary *)response
{
//    "access_token" = 69f97cc9f84d7678ece3a37fde028b8b3898eb6e3f6d2a20a25c81cafab4acff;
//    "expires_in" = 5184000;
//    "scope" = "public private";
//    "token_type" = bearer;

    // TODO: need an object to hold these values
    // TODO: submit to server

    self.token = response[@"access_token"];
    self.expiresIn = response[@"expires_in"];
    self.scope = response[@"scope"];
    self.tokenType = response[@"token_type"];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.expiresIn = [f numberFromString:response[@"expires_in"]];
}

- (NSDictionary *)toPayload
{
    NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:[self.expiresIn integerValue]];

    // TODO: request user

    return @{
//            @"username": self.user[@"username"],
//            @"service_user_id": self.user[@"id"],
            @"service": @"product_hunt",
            @"token": self.token,
            @"token_type": self.tokenType,
            @"scope": self.scope,
            @"expiry_date": [[NSDateFormatter ISO8601] stringFromDate:expiryDate]
    };
}

- (void)getUserInfo:(void (^)(ServiceUserInfo *userInfo))success
{
    // TODO: request /v1/me to get user object
//    NSDictionary *user = @{
//            @"id" : response[@"user"][@"id"],
//            @"website" : response[@"user"][@"website"],
//            @"profile_picture" : response[@"user"][@"profile_picture"],
//            @"bio" : response[@"user"][@"bio"],
//            @"full_name" : response[@"user"][@"full_name"],
//            @"username" : response[@"user"][@"username"]
//    };

    // TODO: implement

    success(nil);
}

- (NSURL *)accessTokenUrl
{
    return [NSURL URLWithString:@"https://api.producthunt.com/v1/oauth/token"];
}

- (NSString *)clientId
{
#ifdef DEBUG
    return @"4860891ff86ee932071e1a4c0baa6bfbcb99b377c0d4e6e7535dd02719e05de8";
#else
    return @"95930b15327364434d9c5f1e0c58f38bf1ef397f56f84f415f9ecfe4e0934e54";
#endif
}

- (NSString *)clientSecret
{
#ifdef DEBUG
    return @"37c646b2137ba823737eb8f1527eb59cfa5949b1cae5a686cf7bcb989df5a588";
#else
    return @"2731295d17ae4b2b7e507d8fed13cf919c60cd739fda6194650fe31d9979f30f";
#endif
}

- (NSString *)callbackUrl
{
    return @"epicglue://product_hunt";
}

@end