//
//  YelpCell.m
//  Yelp
//
//  Created by David Bernthal on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation YelpCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithEntry:(YelpEntry*)entry
{
    self.nameLabel.text = entry.name;
    [self.nameLabel sizeToFit];
    self.reviewLebel.text = [NSString stringWithFormat:@"%@", entry.reviewCount];
    if (entry.address.count == 0)
        self.addressLabel.text = @"No address";
    else
        self.addressLabel.text = entry.address[0]; //Use first entry
    NSMutableString *categories = [[NSMutableString alloc] init];
    for (NSString *category in entry.categories[0]) {
        [categories appendString:[NSString stringWithFormat:@"%@, ", category]];
    }
    self.categoriesLabel.text = categories;
    
    NSURL *imageURL = [NSURL URLWithString:entry.imageURL];
    [self.yelpImageView setImageWithURL:imageURL];
    self.yelpImageView.layer.cornerRadius = 5;
    self.yelpImageView.clipsToBounds = YES;
    NSURL *ratingURL = [NSURL URLWithString:entry.ratingsURL];
    [self.ratingsImageView setImageWithURL:ratingURL];
}

@end
