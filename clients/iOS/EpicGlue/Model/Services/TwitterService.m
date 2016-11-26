//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "TwitterService.h"

#import "ServiceUserInfo.h"
#import "Settings.h"


@implementation TwitterService

+ (NSString *)name
{
    return Twitter;
}

- (NSURL *)authUrl
{
    NSString *baseUrl = @"https://api.twitter.com/oauth/request_token";
    NSString *url = [NSString stringWithFormat:@"%@?oauth_callback=%@", baseUrl, [self callbackUrl]];
    return [NSURL URLWithString:url];
}

- (void)processResponse:(NSDictionary *)response
{
    NSString *accessToken = response[@"access_token"];

    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    for (NSString *group in [accessToken componentsSeparatedByString:@"&"]) {
        NSArray *keyValue = [group componentsSeparatedByString:@"="];
        object[keyValue[0]] = keyValue[1];
    }

    self.token = object[@"oauth_token"];
    self.tokenSecret = object[@"oauth_token_secret"];
    self.xAuthExpires = object[@"x_auth_expires"];
    self.user = @{
            @"id": object[@"user_id"],
            @"username": object[@"screen_name"]
    };

    DDLogDebug(@"%@", object);
}

- (NSDictionary *)toPayload
{
    return @{
            @"service": @"twitter",
            @"username": self.user[@"username"],
            @"user_id": self.user[@"id"],
            @"token": self.token,
            @"token_secret": self.tokenSecret,
    };
}

- (NSString *)clientId
{
#ifdef DEBUG
    return @"eVgB2VmLwKZnGLZ4BgEH0mZta";
#else
    return @"YaPufDcj2x1XE8AcRCYJnIWNh";
#endif
}

- (NSString *)clientSecret
{
#ifdef DEBUG
    return @"rE84LmfT3hRemy9PTaMHP1zJyAtKYrno64xpuSBhmCBvnEjzNM";
#else
    return @"lmzmU35hA6XwDdwkZjdFT5PazmSiT0YscPJB5s2D1B2eZP6yaC";
#endif
}

- (NSString *)callbackUrl
{
    return @"epicglue://twitter";
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