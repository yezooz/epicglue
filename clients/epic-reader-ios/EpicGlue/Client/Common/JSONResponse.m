//
// Created by Marek Mikuliszyn on 19/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "JSONResponse.h"
#import "APIError.h"


@implementation JSONResponse

+ (JSONResponse *)fromJSON:(id)json
{
    if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"data"] != nil) {
        json = [json objectForKey:@"data"];

        if ([json isKindOfClass:[NSDictionary class]]) {
            return [[JSONResponse alloc] initWithDict:json];
        } else {
            return [[JSONResponse alloc] initWithArray:json];
        }
    }

    if ([json isKindOfClass:[NSDictionary class]]) {
        if ([[(NSDictionary *) json allKeys] count] == 0) {
            return nil;
        }
        return [[JSONResponse alloc] initWithDict:json];
    } else if ([json isKindOfClass:[NSArray class]]) {
        if ([(NSArray *) json count] == 0) {
            return nil;
        }
        return [[JSONResponse alloc] initWithArray:json];
    }
    return nil;
}

- (JSONResponse *)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _array = array;
    }

    return self;
}

- (JSONResponse *)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _dict = dict;
    }

    return self;
}

- (BOOL)isError
{
    return self.dict != nil && self.dict[@"error"] != nil;
}

- (APIError *)getError
{
    if ([self isError]) {
        NSInteger code = 0;
        if (self.dict[@"error_code"] != nil) {
            code = [self.dict[@"error_code"] integerValue];
        }
        return [APIError errorWithDomain:@"com.onlyepicapps.epicglue.api" code:code userInfo:@{NSLocalizedDescriptionKey: self.dict[@"error"]}];
    }

    return nil;
}

@end