//
//  TweetCell.h
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "User.h"
#import "Tweet.h"
#import <UIKit/UIKit.h>

@class TweetCell;

@protocol TweetCellDelegate <NSObject>
-(void)onProfileTapped:(User *)user;


@end

@interface TweetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) User *user;
@property (nonatomic, weak) id <TweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;
@end
