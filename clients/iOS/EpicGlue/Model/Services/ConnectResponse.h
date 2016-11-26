//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//



@protocol ConnectResponse <NSObject>

- (NSString *)accessToken;

@optional
- (NSDictionary *)userObject;

@end