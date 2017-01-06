//
// Created by Marek Mikuliszyn on 19/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "DateParser.h"


@implementation DateParser

// Converting "2013-04-18T08:49:58.157+0000" to NSDate
+ (NSDate *)dateFromString:(NSString *)dateString
{
    if ([dateString isKindOfClass:[NSNull class]]) {
        return nil;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:dateString];

    if (date == nil) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        // Always use this locale when parsing fixed format date strings
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:posix];
        NSDate *date = [formatter dateFromString:dateString];

        return date;
    }

    return date;
}

@end