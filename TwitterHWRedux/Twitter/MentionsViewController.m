//
//  MentionsViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetCell.h"
#import "User.h"
#import "TweetDetailViewController.h"
#import "MentionsViewController.h"
#import "NewTweetViewController.h"
#import "ProfileViewController.h"

@interface MentionsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *tweetsArray;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Mentions";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCompose)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    [[TwitterClient sharedInstance] mentionsTimelineWithParams:dictionary completion:^(NSArray *tweets, NSError *error) {
        if(error == nil)
        {
            self.tweetsArray = tweets;
            [self.tableView reloadData];
        }
        else{
            NSLog(@"error");
        }
        
    }];
//
//    // add pull to refresh tweets control
//    self.refreshTweetsControl = [[UIRefreshControl alloc] init];
//    [self.tableView addSubview:self.refreshTweetsControl];
//    [self.refreshTweetsControl addTarget:self action:@selector(refreshMentions) forControlEvents:UIControlEventValueChanged];
//    
//    // show loading indicator
//    self.loadingIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self refreshMentions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onLogout{
    NSLog(@"Logging out");
    [User logout];
}
- (void)onCompose{
    NewTweetViewController *vc = [[NewTweetViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.translucent = NO;
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.delegate = self;
    vc.tweetObj = self.tweetsArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    tweetCell.tweetTextLabel.text = tweet.text;
    tweetCell.userName.text = tweet.author.name;
    
    
    
    NSString *ImageURL = tweet.author.profileImageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    tweetCell.profileImage.layer.cornerRadius = 10.0;
    
    [tweetCell.profileImage setClipsToBounds:YES];
    tweetCell.profileImage.image = [UIImage imageWithData:imageData];
    
    tweetCell.timeLabel.text = [Tweet retrivePostTime:tweet.createdAt];
   
    NSString *handle = [NSString stringWithFormat:@"@%@", tweet.author.screenname];
    tweetCell.handleLabel.text =  handle;
    
    
    UIImage *replyBtnImage = [UIImage imageNamed:@"replyBtn.png"];
    [tweetCell.replyButton setImage:replyBtnImage forState:UIControlStateNormal];
    
    UIImage *retweetBtnImage = [UIImage imageNamed:@"retweetBtn.png"];
    UIImage *retweetOnBtnImage = [UIImage imageNamed:@"retweet_on.png"];
    [tweetCell.retweetButton setImage:retweetBtnImage forState:UIControlStateNormal];
    
    UIImage *favBtnImage = [UIImage imageNamed:@"favoriteBtn.png"];
    UIImage *favBtnImageSelected = [UIImage imageNamed:@"star-selected.png"];
    
    
    tweetCell.delegate = self;
    
    return tweetCell;
}

//- (void)didTweet:(Tweet *)tweet {
//    // process the tweet if it mentions logged in user, and then show it
//    NSString *mentionPattern = [NSString stringWithFormat:@"@%@", [[User currentUser] screenname]];
//    if ([tweet.text rangeOfString:mentionPattern].location != NSNotFound) {
//        NSLog(@"tweet mentioned self, so adding it to list");
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tweets];
//        [temp insertObject:tweet atIndex:0];
//        self.tweets = [temp copy];
//        [self.tableView reloadData];
//    }
//}
//
//- (void)didTweetSuccessfully {
//    // so a newly generated tweet can be replied or favorited
//    [self.tableView reloadData];
//}
//
//- (void)refreshMentions {
//    [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
//        if (error) {
//            NSLog([NSString stringWithFormat:@"Error getting mentions timeline, too many requests?: %@", error]);
//        } else {
//            self.tweets = tweets;
//            [self.tableView reloadData];
//        }
//        [self.loadingIndicator hide:YES];
//        [self.refreshTweetsControl endRefreshing];
//        [self.tableView setHidden:NO];
//    }];
//}
//
//- (void)didReply:(Tweet *)tweet {
//    [self didTweet:tweet];
//}
//
//- (void)didRetweet:(BOOL)didRetweet {
//    [self.tableView reloadData];
//}
//
//- (void)didFavorite:(BOOL)didFavorite {
//    [self.tableView reloadData];
//}
//
//- (void) getMoreTweets {
//    // if no previous max id str available, then don't do anything
//    NSString *maxIdStr = [self.tweets[self.tweets.count - 1] idStr];
//    if (!maxIdStr) {
//        return;
//    }
//    [[TwitterClient sharedInstance] mentionsTimelineWithParams:@{ @"max_id": maxIdStr} completion:^(NSArray *tweets, NSError *error) {
//        // reload only if there is more data
//        if (error) {
//            NSLog([NSString stringWithFormat:@"Error getting more tweets, too many requests?: %@", error]);
//        } else if (tweets.count > 0) {
//            // ignore duplicate requests
//            if ([[tweets[tweets.count - 1] idStr] isEqualToString:[self.tweets[self.tweets.count - 1] idStr]]) {
//                NSLog(@"Ignoring duplicate data");
//            } else {
//                NSLog([NSString stringWithFormat:@"Got %lu more tweets", (unsigned long)tweets.count]);
//                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tweets];
//                [temp addObjectsFromArray:tweets];
//                self.tweets = [temp copy];
//                [self.tableView reloadData];
//            }
//        } else {
//            NSLog(@"No more tweets retrieved");
//        }
//    }];
//}
//
//- (void)onReply:(TweetCell *)tweetCell {
//    ComposeViewController *vc = [[ComposeViewController alloc] init];
//    vc.delegate = self;
//    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//    nvc.navigationBar.translucent = NO;
//    // set reply to tweet property
//    vc.replyToTweet = tweetCell.tweet;
//    [self.navigationController presentViewController:nvc animated:YES completion:nil];
//}
//
- (void)onProfile:(User *)user {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    //[pvc setUser:user];
    //[self.navigationController pushViewController:pvc animated:YES];
}
//

@end
