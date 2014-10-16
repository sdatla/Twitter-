//
//  TweetsViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TweetCell.h"
#import <UIKit/UIKit.h>
#import "TweetDetailViewController.h"

@protocol TweetsViewControllerDelegate <NSObject>


@end

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetDetailViewControllerDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweetDetails;
@property (strong, nonatomic) NSArray *tweetArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)onSignOut;
- (IBAction)onCompose;
-(void)onProfileTapped:(User *)user;
@property (nonatomic, weak) id <TweetsViewControllerDelegate> delegate;

@end
