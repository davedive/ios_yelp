//
//  YelpCell.h
//  Yelp
//
//  Created by David Bernthal on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpEntry.h"

@interface YelpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *yelpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLebel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (void)initWithEntry:(YelpEntry*)entry;

@end
