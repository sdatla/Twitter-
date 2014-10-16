//
//  ProfileViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TweetCell.h"
#import "User.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    
    if(self.user == nil)
    {
    self.user = [User currentUser];

    }
    else{
        
    }
    
    NSString *ImageURL = self.user.bkgImageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    self.bkgImage.image = [UIImage imageWithData:imageData];
    
    NSString *ImageURLP = self.user.profileImageURL;
    NSData *imageDataP = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURLP]];
    
    self.profileImg.layer.cornerRadius = 10.0;
    [self.profileImg setClipsToBounds:YES];
    self.profileImg.image = [UIImage imageWithData:imageDataP];
    
    self.numTweets.text = self.user.numTweets;
    self.numFollowing.text = self.user.numFollowing;
    self.numFollowers.text = self.user.numFollowers;
    
    self.userName.text = self.user.name;
    
    NSString *handle = [NSString stringWithFormat:@"@%@", self.user.screenname];
    
    self.userHandle.text = handle;
    
    [[TwitterClient sharedInstance] userTimelineWithParams:dictionary user:self.user completion:^(NSArray *tweets, NSError *error) {
        if(error == nil)
        {
            self.tweetsArray = tweets;
            
            [self.tableView reloadData];
        }
        else{
            NSLog(@"error");
        }
        
    }];
    
     self.navigationItem.title = @"Me";
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    // Do any additional setup after loading the view from its nib.
    

    

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;



    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    tweetCell.tweetTextLabel.text = tweet.text;
    tweetCell.userName.text = tweet.author.name;
    
    tweetCell.user = tweet.author;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    Tweet *twObj= [self.tweetsArray objectAtIndex:indexPath.row];
    NSLog(@"The obj is %@", twObj);
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil tweet:twObj];
    vc.popToVC = self;
    [[self navigationController] pushViewController:vc animated:YES];
    
    
}

-(void)onProfileTapped:(User *)user{
    NSLog(@"Responding");
    self.user = user;
    [self.tableView reloadData];
}

@end


