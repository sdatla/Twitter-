//
//  ProfileViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TweetCell.h"

@protocol ProfileViewControllerDelegate <NSObject>


@end


@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (nonatomic, weak) id <ProfileViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;
-(void)onProfileTapped:(User *)user;

@property (strong, nonatomic) IBOutlet UIImageView *bkgImage;
@property (strong, nonatomic) IBOutlet UILabel *numTweets;
@property (strong, nonatomic) IBOutlet UILabel *numFollowing;
@property (strong, nonatomic) IBOutlet UILabel *numFollowers;
@property (strong, nonatomic) IBOutlet UIImageView *profileImg;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userHandle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweetsArray;

@end
