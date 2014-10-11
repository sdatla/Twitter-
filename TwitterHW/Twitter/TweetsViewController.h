//
//  TweetsViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweetDetails;
@property (strong, nonatomic) NSArray *tweetArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)onSignOut;
- (IBAction)onCompose;

@end
