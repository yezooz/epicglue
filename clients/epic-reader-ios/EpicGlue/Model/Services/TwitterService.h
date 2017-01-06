//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//


#import "ConnectableService.h"


@interface TwitterService : NSObject <ConnectableService>

@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *tokenSecret;
@property(nonatomic, copy) NSString *xAuthExpires;
@property(nonatomic, copy) NSDictionary *user;

- (void)processResponse:(NSDictionary *)response;
@end