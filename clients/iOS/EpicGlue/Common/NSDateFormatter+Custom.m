//
// Created by Marek Mikuliszyn on 23/04/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "NSDateFormatter+Custom.h"


@implementation NSDateFormatter (Custom)

+ (NSDateFormatter *)ISO8601
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

    return dateFormatter;
}

@end