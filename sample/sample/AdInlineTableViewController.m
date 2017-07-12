//
//  AdInlineTableViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdInlineTableViewController.h"
#import <AdformAdvertising/AdformAdvertising.h>

static NSInteger const kAdInlineTag = 101;

@interface AdInlineTableViewController () <AFAdInlineDelegate>

@property (nonatomic, strong) NSMutableDictionary *footers;

@end

@implementation AdInlineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.footers = [NSMutableDictionary new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger )masterTag {
    
    return 142493;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    // Just some dummy content.
    cell.textLabel.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // To animate table view when ad is laoded we have to provide footer size dinamically.
    return [self sizeOfFooterAtSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // It is very important to reuse ad views. You can use the default table view caching mechanizm for that, but in this example
    // we use seperate dictionary. We need it for animations, we have to bind ads to sections. We check footer size based on ad state.
    UITableViewHeaderFooterView *footerView = self.footers[@(section)];
    
    AFAdInline *adInline;
    
    if (!footerView) {
        // If footer view is not retreived from cache, create a new one.
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        
        // Create and setup a new adInline object.
        adInline = [[AFAdInline alloc] initWithMasterTagId:[self masterTag] presentingViewController:self];
        
        // Center the ad in footer.
        CGRect frame = adInline.frame;
        frame.origin = CGPointMake((footerView.frame.size.width - frame.size.width) / 2, 0);
        adInline.frame = frame;
        adInline.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        
        // This line of code enables multiple ad size support.
        adInline.additionalDimmensionsEnabled = true;
        
        adInline.delegate = self;
        adInline.tag = kAdInlineTag;
        
        // Add it to footer view and initiate ad loading.
        [footerView.contentView addSubview:adInline];
        [adInline loadAd];
        
        self.footers[@(section)] = footerView;
    }
    
    return footerView;
}

#pragma mark - Content resizing
/**
 Returns ad size, when ad is loaded otherwise 1.
 */
- (CGFloat )sizeOfFooterAtSection:(NSInteger )section {
    
    // Get ad from footer.
    AFAdInline *adInline = (AFAdInline *)[self.footers[@(section)] viewWithTag:kAdInlineTag];
    
    // Return correct ad size only when adInline is not null and ad is loaded.
    // Ad is laoded if its state is AFAdStateVisible or AFAdStateInTransition (ad is going to be visible after animation).
    if (adInline && (adInline.state == AFAdStateVisible || adInline.state == AFAdStateInShowTransition)) {
        return adInline.adSize.height;
    } else {
        // There is an issue that if you return 0 here, 'tableView:viewForFooterInSection:' doesn't get called.
        return 1;
    }
}

#pragma mark - AFAdInlineDelegate

- (void)adInlineWillShow:(AFAdInline *)adInline {
    
    // When ad is about to begin presentation we just need to start table view updates.
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    NSLog(@"Finish");
}

@end
