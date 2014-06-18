//
//  FiltersViewController.m
//  Yelp
//
//  Created by David Bernthal on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SearchResultsViewController.h"

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) NSMutableDictionary *categoryMap;
@property (strong, nonatomic) NSMutableDictionary *categorySearchMap;
@property (strong, nonatomic) NSMutableDictionary *sortByMap;
@property (strong, nonatomic) NSMutableDictionary *sortBySearchMap;
@property (strong, nonatomic) NSMutableDictionary *distanceMap;
@property (strong, nonatomic) NSMutableDictionary *distanceSearchMap;
@property (strong, nonatomic) NSMutableDictionary *sectionHeaders;

@property (strong, nonatomic) NSMutableDictionary *collapsedSections;
@property (strong, nonatomic) NSMutableDictionary *collapsedRowCounts;
@property (strong, nonatomic) NSMutableDictionary *shortRowCounts;

@property (strong, nonatomic) NSNumber *selectedCategoryIndex;
@property (strong, nonatomic) NSNumber *selectedSortByIndex;
@property (strong, nonatomic) NSNumber *selectedDistanceIndex;
@property BOOL deals;

@property (strong, nonatomic) UISwitch* dealsSwitch;


@end



@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.collapsedSections = [[NSMutableDictionary alloc] init];
        
        self.sectionHeaders = [[NSMutableDictionary alloc] init];
        self.sectionHeaders[@(0)] = @"Category";
        self.sectionHeaders[@(1)] = @"Sort By";
        self.sectionHeaders[@(2)] = @"Most Popular";
        self.sectionHeaders[@(3)] = @"Distance";
        
        self.shortRowCounts = [[NSMutableDictionary alloc] init];
        self.shortRowCounts[@(0)] = @(4);
        self.shortRowCounts[@(1)] = @(1);
        self.shortRowCounts[@(2)] = @(1);
        self.shortRowCounts[@(3)] = @(1);
        
        self.categoryMap = [[NSMutableDictionary alloc] init];
        self.categoryMap[@(0)] = @"Restaurants";
        self.categoryMap[@(1)] = @"Nightlife";
        self.categoryMap[@(2)] = @"Shopping";
        self.categoryMap[@(3)] = @"Active Life";
        self.categoryMap[@(4)] = @"Arts";
        self.categoryMap[@(5)] = @"Education";
        self.categoryMap[@(6)] = @"Financial";
        self.categoryMap[@(7)] = @"Medical";
        self.categoryMap[@(8)] = @"Travel";
        self.categoryMap[@(9)] = @"Pets";
        
        self.categorySearchMap = [[NSMutableDictionary alloc] init];
        self.categorySearchMap[@(0)] = @"restaurants";
        self.categorySearchMap[@(1)] = @"nightlife";
        self.categorySearchMap[@(2)] = @"shopping";
        self.categorySearchMap[@(3)] = @"active";
        self.categorySearchMap[@(4)] = @"arts";
        self.categorySearchMap[@(5)] = @"education";
        self.categorySearchMap[@(6)] = @"financialservices";
        self.categorySearchMap[@(7)] = @"health";
        self.categorySearchMap[@(8)] = @"hotelstravel";
        self.categorySearchMap[@(9)] = @"pets";
        
        self.sortByMap = [[NSMutableDictionary alloc] init];
        self.sortByMap[@(0)] = @"Best Match";
        self.sortByMap[@(1)] = @"Distance";
        self.sortByMap[@(2)] = @"Highest Rated";
        
        self.sortBySearchMap = [[NSMutableDictionary alloc] init];
        self.sortBySearchMap[@(0)] = @"0";
        self.sortBySearchMap[@(1)] = @"1";
        self.sortBySearchMap[@(2)] = @"2";
        
        self.distanceMap = [[NSMutableDictionary alloc] init];
        self.distanceMap[@(0)] = @"0.3 Miles";
        self.distanceMap[@(1)] = @"1 mile";
        self.distanceMap[@(2)] = @"5 miles";
        self.distanceMap[@(3)] = @"20 miles";
        
        self.distanceSearchMap = [[NSMutableDictionary alloc] init];
        self.distanceSearchMap[@(0)] = @"482";
        self.distanceSearchMap[@(1)] = @"1609";
        self.distanceSearchMap[@(2)] = @"8046";
        self.distanceSearchMap[@(3)] = @"32186";
        
        self.collapsedRowCounts = [[NSMutableDictionary alloc] init];
        self.collapsedRowCounts[@(0)] = @(self.categoryMap.count);
        self.collapsedRowCounts[@(1)] = @(self.sortByMap.count);
        self.collapsedRowCounts[@(2)] = @(self.distanceMap.count);
        self.collapsedRowCounts[@(3)] = @(1);
        
        self.selectedCategoryIndex = nil;
        self.selectedSortByIndex = [NSNumber numberWithInt:0];
        self.selectedDistanceIndex = [NSNumber numberWithInt:0];
        
        self.dealsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 7, 0, 0)];
        self.deals = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
    [self.filterTableView reloadData];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    [self.dealsSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.collapsedSections[@(section)] boolValue])
    {
        return [self.shortRowCounts[@(section)] integerValue];
    } else
    {
        return [self.collapsedRowCounts[@(section)] integerValue];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaders.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0:
            if (![self.collapsedSections[@(0)] boolValue] &&
                (indexPath.row == [self.shortRowCounts[@(0)] integerValue] - 1))
                cell.textLabel.text = @"See All";
            else
                cell.textLabel.text = self.categoryMap[@(indexPath.row)];
            break;
        case 1:
            if (![self.collapsedSections[@(1)] boolValue])
                cell.textLabel.text = self.sortByMap[self.selectedSortByIndex];
            else
                cell.textLabel.text = self.sortByMap[@(indexPath.row)];
            break;
        case 2:
            if (![self.collapsedSections[@(2)] boolValue])
                cell.textLabel.text = self.distanceMap[self.selectedDistanceIndex];
            else
                cell.textLabel.text = self.distanceMap[@(indexPath.row)];
            break;
        case 3:
            cell.textLabel.text = @"Offering a Deal";
            [cell addSubview:self.dealsSwitch];
            break;
        default:
            break;
    }
    return  cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaders[@(section)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (![self.collapsedSections[@(0)] boolValue] && indexPath.row == [self.shortRowCounts[@(0)] integerValue] - 1)
            {
                self.collapsedSections[@(indexPath.section)] = @true;
                [self reloadTableSection:indexPath.section];
            } else
                self.selectedCategoryIndex = [NSNumber numberWithInteger:indexPath.row];
            break;
        case 1:
            if (![self.collapsedSections[@(1)] boolValue])
            {
                self.collapsedSections[@(indexPath.section)] = @true;
                [self reloadTableSection:indexPath.section];
            } else
            {
                self.selectedSortByIndex = [NSNumber numberWithInteger:indexPath.row];
                self.collapsedSections[@(indexPath.section)] = @false;
                [self reloadTableSection:indexPath.section];
            }
            break;
        case 2:
            if (![self.collapsedSections[@(2)] boolValue])
            {
                self.collapsedSections[@(indexPath.section)] = @true;
                [self reloadTableSection:indexPath.section];
            } else
            {
                self.selectedDistanceIndex = [NSNumber numberWithInteger:indexPath.row];
                self.collapsedSections[@(indexPath.section)] = @false;
                [self reloadTableSection:indexPath.section];
            }
            break;
        case 3:
            //Switch
            break;
        default:
            break;
    }

}

- (void)reloadTableSection:(NSInteger)section
{
    [self.filterTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onSearchButton
{
    NSString* categoryFilter = [[NSString alloc] init];
    if (self.categorySearchMap[self.selectedCategoryIndex] == nil)
    {
        categoryFilter = @"";
    } else
    {
        categoryFilter = self.categorySearchMap[self.selectedCategoryIndex];
    }
    NSDictionary* searchParameters = @{@"category_filter" : categoryFilter, @"radius_filter" : self.distanceSearchMap[self.selectedDistanceIndex],
                                       @"sort" : self.sortBySearchMap[self.selectedSortByIndex], @"deals_filter" : [NSNumber numberWithBool:self.deals]};
    
    [self.delegate addSearchTermsViewController:self didFinishEnteringTerms:searchParameters];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSwitch:(id)sender
{
    if ([sender isOn])
        self.deals = YES;
    else
        self.deals = NO;
}


@end
