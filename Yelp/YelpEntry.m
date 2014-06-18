//
//  YelpEntry.m
//  Yelp
//
//  Created by David Bernthal on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpEntry.h"

@implementation YelpEntry

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"imageURL": @"image_url",
        @"ratingsURL": @"rating_img_url",
        @"name": @"name",
        @"reviewCount": @"review_count",
        @"address": @"location.address", //Check this
        @"categories": @"categories"
    };
}

+ (NSArray *)entriesWithArray:(NSArray *)array {
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        YelpEntry *entry = [MTLJSONAdapter modelOfClass:YelpEntry.class fromJSONDictionary:dictionary error:nil];
        [entries addObject:entry];
    }
    
    return entries;
}

@end
