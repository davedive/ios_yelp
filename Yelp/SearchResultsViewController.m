//
//  SearchResultsViewController.m
//  Yelp
//
//  Created by David Bernthal on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "FiltersViewController.h"
#import "YelpClient.h"
#import "YelpEntry.h"
#import "YelpCell.h"

NSString * const kYelpConsumerKey = @"upFZ4lirojAlMIUgUYEYuA";
NSString * const kYelpConsumerSecret = @"MFMhPw5sblhXOApW984It6Q5RR4";
NSString * const kYelpToken = @"FAbrtk0hgC4SnpJU8E-Uq3JiQAcj-RTq";
NSString * const kYelpTokenSecret = @"Q8Spf3B-ldYB1t7BLB3qbU4Xkq0";

@interface SearchResultsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *YelpTableView;
@property (nonatomic, strong) NSArray* entries;
@property (nonatomic, strong) YelpClient *client;

@property (strong, nonatomic) NSString* term;
@property (strong, nonatomic) NSDictionary* searchTerms;
@property (strong, nonatomic) UISearchBar* searchBar;

@property (strong, nonatomic) YelpCell* stubCell;

@end

@implementation SearchResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.YelpTableView.dataSource = self;
    self.YelpTableView.delegate = self;
    self.term = @""; //Default search
    [self.YelpTableView registerNib:[UINib nibWithNibName:@"YelpCell" bundle:nil] forCellReuseIdentifier:@"YelpCell"];
    self.stubCell = [self.YelpTableView dequeueReusableCellWithIdentifier:@"YelpCell"];
    
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    // Set Up Search Bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 0.0, 200.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.searchBar setKeyboardType:UIKeyboardTypeWebSearch];
    [self.searchBar setBarTintColor:[UIColor redColor]];
    [self.searchBar setTintColor:[UIColor blackColor]];
    self.searchBar.delegate = self;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 230.0, 44.0)];
//    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    [self loadEntries];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadEntries];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadEntries
{
    [self.client searchWithTerm:self.term parameters:self.searchTerms success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.entries = [YelpEntry entriesWithArray:response[@"businesses"]];
        
        [self.YelpTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    YelpEntry *entry = self.entries[indexPath.row];
//    YelpCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YelpCell"];
//    CGSize practiceSize = [entry.name sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, 1000.0f)];
//    return practiceSize.height + 100; //For the other, less dynamic labels
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.stubCell initWithEntry:self.entries[indexPath.row]];
    [self.stubCell layoutSubviews];
    
    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YelpCell"];
    [cell initWithEntry:self.entries[indexPath.row]];
    return cell;
}

- (void)onFilterButton
{
    FiltersViewController *filterVC = [[FiltersViewController alloc] init];
    filterVC.delegate = self;
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)addSearchTermsViewController:(FiltersViewController *)controller didFinishEnteringTerms:(NSDictionary *)terms
{
    self.searchTerms = terms;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.YelpTableView.allowsSelection = NO;
    self.YelpTableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.YelpTableView.allowsSelection = YES;
    self.YelpTableView.scrollEnabled = YES;
    [self loadEntries];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.term = searchBar.text;
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.YelpTableView.allowsSelection = YES;
    self.YelpTableView.scrollEnabled = YES;
	
    [self loadEntries];
}

@end
