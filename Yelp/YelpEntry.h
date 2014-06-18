//
//  YelpEntry.h
//  Yelp
//
//  Created by David Bernthal on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface YelpEntry : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *ratingsURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *reviewCount;
@property (strong, nonatomic) NSArray *address;
@property (strong, nonatomic) NSArray *categories;

+ (NSArray *)entriesWithArray:(NSArray *)array;

@end
