//
//  MentionsViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "Tweet.h"
#import "TweetCell.h"
#import "NewTweetViewController.h"
#import <UIKit/UIKit.h>

@protocol MentionsViewControllerDelegate <NSObject>


@end

@interface MentionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NewTweetViewControllerDelegate, TweetDetailViewControllerDelegate, TweetCellDelegate>
@property (nonatomic, weak) id <MentionsViewControllerDelegate> delegate;
@end
