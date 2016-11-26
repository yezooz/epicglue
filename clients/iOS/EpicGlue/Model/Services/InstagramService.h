//
// Created by Marek Mikuliszyn on 04/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//


#import "ConnectableService.h"


@interface InstagramService : NSObject <ConnectableService>

@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSDictionary *user;

@end