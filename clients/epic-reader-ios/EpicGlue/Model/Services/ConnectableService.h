//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//



@class ServiceUserInfo;

@protocol ConnectableService <NSObject>
+ (NSString *)name;

- (NSURL *)authUrl;

- (void)processResponse:(NSDictionary *)response;

- (void)setToken:(NSString *)token;

- (NSDictionary *)user;

- (void)setUser:(NSDictionary *)user;

- (NSDictionary *)toPayload;

- (void)getUserInfo:(void (^)(ServiceUserInfo *userInfo))success;

@optional
- (NSString *)clientId;

- (NSString *)clientSecret;

- (NSString *)tokenType;

- (NSString *)scope;

- (NSNumber *)expiresIn;

- (NSString *)callbackUrl;

- (NSURL *)accessTokenUrl;

- (void)setRefreshToken:(NSString *)token;
@end