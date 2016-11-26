//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//


#import "ConnectableService.h"


@interface RedditService : NSObject <ConnectableService>

@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *refreshToken;
@property(nonatomic, copy) NSNumber *expiresIn;
@property(nonatomic, copy) NSString *tokenType;
@property(nonatomic, copy) NSString *scope;
@property(nonatomic, copy) NSDictionary *user;

@end