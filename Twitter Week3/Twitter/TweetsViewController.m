//
//  TweetsViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "User.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetsTableView.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"
#import "NewTweetViewController.h"


@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweetDetails;
@property (strong, nonatomic) NSArray *tweetArray;
@property (nonatomic, strong) TweetCell *prototypeCell;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)onSignOut;
- (IBAction)onCompose;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self invokeApiCall];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // pull down refresh

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(invokeApiCall) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor colorWithRed:0.00 green:0.60 blue:0.00 alpha:1.00]];
    [self.tableView addSubview:self.refreshControl];
    
    
    
    UIColor *blue = [UIColor colorWithRed:102.0/255 green:178.0/255 blue:255.0/255 alpha:1.00];
    self.navigationController.navigationBar.barTintColor = blue;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    

    self.navigationItem.title = @"Home";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.rowHeight = 120;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];

    
    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Sign Out"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(onSignOut)];
    self.navigationItem.leftBarButtonItem = logOutButton;
   
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"New"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(onCompose)];
    self.navigationItem.rightBarButtonItem = newButton;
   

}

-(void)invokeApiCall{
    // Do any additional setup after loading the view from its nib.
    NSArray *keys = [NSArray arrayWithObjects:@"timeline", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"20", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:dictionary completion:^(NSArray *tweets, NSError *error) {
        if(error == nil)
        {
            self.tweetArray = tweets;
            [self.tableView reloadData];
        }
        else{
            NSLog(@"error");
        }
        
    }];
    
    [self.refreshControl endRefreshing];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignOut {
    NSLog(@"Logging out");
    [User logout];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addTweet:(Tweet *) tweet{
    
}
- (IBAction)onCompose {
    
    NSLog(@"Composing tweet");
    NewTweetViewController *ntw = [[NewTweetViewController alloc] init];
    [ntw setCallback:self];
    [self.navigationController pushViewController:ntw animated:YES];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath isForOffscreenUse:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    Tweet *twObj= [self.tweetArray objectAtIndex:indexPath.row];
    NSLog(@"The obj is %@", twObj);
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil tweet:twObj];
    [[self navigationController] pushViewController:vc animated:YES];
    
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    
    [self configureCell:self.prototypeCell forIndexPath:indexPath isForOffscreenUse:YES];
    
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}


-(void) configureCell:(TweetCell*)cell forIndexPath:(NSIndexPath*)indexPath isForOffscreenUse:(BOOL)isForOffscreenUse{
    
    Tweet *tweet = [self.tweetArray objectAtIndex:indexPath.row];    //NSLog(@"These are the tweet %@", self.tweetArray);

            
            cell.tweetTextLabel.text = tweet.text;
    
            NSString *ImageURL = tweet.author.profileImageURL;
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
           cell.profileImage.image = [UIImage imageWithData:imageData];
   
           cell.timeLabel.text = [Tweet retrivePostTime:tweet.createdAt];
            cell.userName.text = tweet.author.name;

   
            NSString *handle = [NSString stringWithFormat:@"@%@", tweet.author.screenname];
            cell.handleLabel.text =  handle;

   
    UIImage *replyBtnImage = [UIImage imageNamed:@"reply.png"];
    [cell.replyButton setImage:replyBtnImage forState:UIControlStateNormal];
    
   UIImage *retweetBtnImage = [UIImage imageNamed:@"retweet.png"];
    [cell.retweetButton setImage:retweetBtnImage forState:UIControlStateNormal];
   
    UIImage *favBtnImage = [UIImage imageNamed:@"star.png"];
    UIImage *favBtnImageSelected = [UIImage imageNamed:@"star-selected.png"];
    if([tweet.favorited intValue] == 0)
    {
        [cell.favoriteButton setImage:favBtnImage forState:UIControlStateNormal];
    }
    else
    {
        [cell.favoriteButton setImage:favBtnImageSelected forState:UIControlStateNormal];
    }


}

- (void)refreshControlRequest
{
    NSLog(@"refreshing");
    [self invokeApiCall];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}
@end
