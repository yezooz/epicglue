//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Response.h"


@interface RegisterByEmailResponse : NSObject <Response>

@property(readonly) NSString *token;

@end