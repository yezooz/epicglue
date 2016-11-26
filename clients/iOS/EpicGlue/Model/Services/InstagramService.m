//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "InstagramService.h"
#import "ServiceUserInfo.h"


@implementation InstagramService

+ (NSString *)name
{
    return @"Instagram";
}

- (NSURL *)authUrl
{
    NSString *baseUrl = @"https://api.instagram.com/oauth/authorize";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code", baseUrl,
                                               [self clientId], [self callbackUrl]];

    return [NSURL URLWithString:url];
}

- (void)processResponse:(NSDictionary *)response
{
    // TODO: need an object to hold these values
    // TODO: submit to server

    self.token = response[@"access_token"];
    self.user = @{
            @"id": response[@"user"][@"id"],
            @"website": response[@"user"][@"website"],
            @"profile_picture": response[@"user"][@"profile_picture"],
            @"bio": response[@"user"][@"bio"],
            @"full_name": response[@"user"][@"full_name"],
            @"username": response[@"user"][@"username"]
    };
}

- (NSDictionary *)toPayload
{
    return @{
            @"service": @"instagram",
            @"username": self.user[@"username"],
            @"user_id": self.user[@"id"],
            @"token": self.token,
    };
}

- (NSURL *)accessTokenUrl
{
    return [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
}

- (NSString *)clientId
{
#ifdef DEBUG
    return @"9fb281a3fc0b4fb383c1767e0623f671";
#else
    return @"31eddad528cc4eed9e5cb2e79d0dff3e";
#endif
}

- (NSString *)clientSecret
{
#ifdef DEBUG
    return @"269931ada8484bb39a51f961abb34ad9";
#else
    return @"f62d65f310894b80964225c7783f7c88";
#endif
}

- (NSString *)callbackUrl
{
    return @"epicglue://instagram";
}

- (void)getUserInfo:(void (^)(ServiceUserInfo *userInfo))success
{
    ServiceUserInfo *userInfo = [[ServiceUserInfo alloc] init];
    // TEMP
    userInfo.userId = self.user[@"id"];
    userInfo.username = self.user[@"username"];

    success(userInfo);
}

@end