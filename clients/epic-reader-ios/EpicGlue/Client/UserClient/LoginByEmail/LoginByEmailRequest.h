//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Request.h"


@interface LoginByEmailRequest : NSObject <Request>

@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *password;

@end