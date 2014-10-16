//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import  "NewTweetViewController.h"

@interface TweetDetailViewController ()

@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tweet:(Tweet *)tweetObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweetObj = tweetObj;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    if([self.tweetObj.favorited intValue] == 1)
    {
         UIImage *favBtnImage = [UIImage imageNamed:@"star-selected.png"];
         [self.favoriteButton setBackgroundImage:favBtnImage forState:UIControlStateNormal];
    }
    if([self.tweetObj.retweeted intValue] == 1)
    {
        UIImage *favBtnImage = [UIImage imageNamed:@"retweet_on.png"];
        [self.retweetButton setBackgroundImage:favBtnImage forState:UIControlStateNormal];
    }

    UIColor *blue = [UIColor colorWithRed:102.0/255 green:178.0/255 blue:255.0/255 alpha:1.00];
    self.navigationController.navigationBar.barTintColor = blue;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Tweet";

    // Do any additional setup after loading the view from its nib.
    NSLog(@"this is the author name %@",self.tweetObj.author.name);
    self.userName.text = self.tweetObj.author.name;
    self.tweettext.text = self.tweetObj.text;
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/d/yyyy hh:mm a"];
    
    NSString *dateString = [format stringFromDate:self.tweetObj.createdAt];
    
    self.timeLabel.text = dateString;
    
    NSString *handle = [NSString stringWithFormat:@"@%@", self.tweetObj.author.screenname];
    self.handleLabel.text = handle;
    
    self.numFavorites.text = [NSString stringWithFormat:@"%ld", (long)self.tweetObj.numFavorites];
      self.numRetweets.text = [NSString stringWithFormat:@"%ld", (long)self.tweetObj.numRetweets];
    
    NSString *ImageURL = self.tweetObj.author.profileImageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.profileImage.layer.cornerRadius = 10.0;
    [self.profileImage setClipsToBounds:YES];
    self.profileImage.image = [UIImage imageWithData:imageData];
    
    //UIImage *retweetImage = [UIImage imageNamed: @"retweetBtn.png"];

    
    UIImage *replyBtnImage = [UIImage imageNamed:@"replyBtn.png"];
    [self.replyButton setImage:replyBtnImage forState:UIControlStateNormal];
    
    UIImage *retweetBtnImage = [UIImage imageNamed:@"retweetBtn.png"];
    [self.retweetButton setImage:retweetBtnImage forState:UIControlStateNormal];
    
    UIImage *favBtnImage = [UIImage imageNamed:@"star.png"];
    [self.favoriteButton setImage:favBtnImage forState:UIControlStateNormal];

    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Reply"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(onReply)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
}


-(IBAction)onReply{
    NSLog(@"Replying to tweet");
    NewTweetViewController *ntw = [[NewTweetViewController alloc] init];
    [ntw setCallback:self tweet:self.tweetObj ];
    ntw.popToThisController = self.popToVC;
    [self.navigationController pushViewController:ntw animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)retweetAction:(id)sender{
    UIImage *favBtnImage = [UIImage imageNamed:@"retweet_on.png"];
    
    if([self.tweetObj.retweeted intValue] == 0)
    {
        [self.retweetButton setBackgroundImage:favBtnImage forState:UIControlStateNormal];
    [[TwitterClient sharedInstance] doRetweet:self.tweetObj.tweetid];
    }
 
    
   //  [self.delegate didRetweet:self.tweetObj.retweeted];
   
}

- (IBAction)favoriteAction:(id)sender {
    UIImage *favBtnImage = [UIImage imageNamed:@"star-selected.png"];
    
    if([self.tweetObj.favorited intValue] == 0)
    {
        [self.favoriteButton setBackgroundImage:favBtnImage forState:UIControlStateNormal];
    [[TwitterClient sharedInstance] doFavorite:self.tweetObj];
    }
    self.tweetObj.numFavorites++;
    [self.view setNeedsDisplay];

   
}

- (IBAction)replyAction:(id)sender {
    [self onReply];
}

-(void)popController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
