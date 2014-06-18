//
//  FiltersViewController.h
//  Yelp
//
//  Created by David Bernthal on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FilterVCDelegate <NSObject>
- (void)addSearchTermsViewController:(FiltersViewController *)controller didFinishEnteringTerms:(NSDictionary *)terms;
@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <FilterVCDelegate> delegate;

@end
