//
//  SearchResultsViewController.h
//  Yelp
//
//  Created by David Bernthal on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltersViewController.h"

@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FilterVCDelegate, UISearchBarDelegate>

@end
